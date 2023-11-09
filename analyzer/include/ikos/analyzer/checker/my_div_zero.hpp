#pragma once

#include <ikos/analyzer/checker/checker.hpp>

namespace ikos {
namespace analyzer {

/// \brief Division by zero checker
class MyDivZero final : public Checker {
  using IntInterval = core::machine_int::Interval;
public:
  /// \brief Constructor
  explicit MyDivZero(Context& ctx);

  /// \brief Get the checker name
  CheckerName name() const override;

  /// \brief Get the checker description
  const char* description() const override;

  /// \brief Check a statement
  void check(ar::Statement* stmt,
             const value::AbstractDomain& inv,
             CallContext* call_context) override;

private:
  /// \brief Check result
  struct CheckResult {
    CheckKind kind;
    Result result;
    JsonDict info;
  };

  /// \brief Check a division
  CheckResult check_division(ar::BinaryOperation* stmt,
                             const value::AbstractDomain& inv);

private:
  /// \brief Dispay the check for the given division, if requested
  llvm::Optional< LogMessage > display_division_check(
      Result result, ar::BinaryOperation* stmt) const;

};

}
}

