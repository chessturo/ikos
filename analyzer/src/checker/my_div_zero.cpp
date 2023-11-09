#include <ikos/analyzer/checker/my_div_zero.hpp>

#include <ikos/analyzer/json/helper.hpp>
#include <ikos/ar/semantic/statement.hpp>
#include "ikos/analyzer/util/log.hpp"

namespace ikos {
namespace analyzer {

using Operator = ar::BinaryOperation::Operator;

static const std::set<Operator> kDivOps = {
  Operator::SDiv,
  Operator::UDiv,
  Operator::SRem,
  Operator::URem,
};

MyDivZero::MyDivZero(Context& ctx) : Checker(ctx) {}

CheckerName MyDivZero::name() const {
  return CheckerName::MyDivZero;
}

const char* MyDivZero::description() const {
  return "[TEST] division by zero checker";
}

void MyDivZero::check(ar::Statement* stmt, const value::AbstractDomain& inv,
    CallContext* call_context) {
  if (auto bin = dyn_cast<ar::BinaryOperation>(stmt)) {
    if (kDivOps.find(bin->op()) != kDivOps.end()) {
      CheckResult res = this->check_division(bin, inv);
      this->display_invariant(res.result, stmt, inv);
      this->_checks.insert(res.kind,
          CheckerName::MyDivZero,
          res.result,
          stmt,
          call_context,
          std::array< ar::Value*, 1 >{{bin->right()}},
          res.info);
      }
  }
}

MyDivZero::CheckResult MyDivZero::check_division(ar::BinaryOperation* stmt,
    const value::AbstractDomain& inv) {
  if (inv.is_normal_flow_bottom()) {
    auto msg = this->display_division_check(Result::Unreachable, stmt);
    return {CheckKind::Unreachable, Result::Unreachable, {}};
  }

  const ScalarLit& rhs = this->_lit_factory.get_scalar(stmt->right());
  if (rhs.is_undefined() ||
      (rhs.is_machine_int() && inv.normal().uninit_is_initialized(rhs.var()))) {
    if (auto msg = this->display_division_check(Result::Error, stmt)) {
      *msg << ": rhs undefined\n";
    }
    return {CheckKind::UninitializedVariable, Result::Error, {}};
  }

  auto divisor = IntInterval::bottom(1, Signed);
  if (rhs.is_machine_int()) {
    divisor = IntInterval(rhs.machine_int());
  } else if (rhs.is_machine_int_var()) {
    divisor = inv.normal().int_to_interval(rhs.var());
  } else {
    log::error("unexpected operand to binary operation");
    return {CheckKind::UnexpectedOperand, Result::Error, {}};
  }

  boost::optional< MachineInt > d = divisor.singleton();

  if (d && d->is_zero()) {
    if (auto msg = this->display_division_check(Result::Error, stmt)) {
      *msg << ": definitely zero\n";
    }
    return {CheckKind::DivisionByZero, Result::Error, {}};
  } else if (divisor.contains(
                 MachineInt::zero(divisor.bit_width(), divisor.sign()))) {
    if (auto msg = this->display_division_check(Result::Error, stmt)) {
      *msg << ": potentially zero\n";
    }
    return {CheckKind::DivisionByZero, Result::Error, to_json(divisor)};
  } else {
    if (auto msg = this->display_division_check(Result::Ok, stmt)) {
      *msg << ": never zero\n";
    }
    return {CheckKind::DivisionByZero, Result::Ok, {}};
  }
}

llvm::Optional< LogMessage > MyDivZero::display_division_check(
    Result result, ar::BinaryOperation* stmt) const {
  auto msg = this->display_check(result, stmt);
  if (msg) {
    *msg << "TEST_dbz(";
    stmt->dump(msg->stream());
    *msg << ")";
  }
  return msg;
}

} // end namespace analyzer
} // end namespace ikos

