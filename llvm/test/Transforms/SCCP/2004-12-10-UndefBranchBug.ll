; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=sccp -S | FileCheck %s

; This function definitely returns 1, even if we don't know the direction
; of the branch.

define i32 @foo() {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    br i1 false, label [[T:%.*]], label [[T]]
; CHECK:       T:
; CHECK-NEXT:    [[X:%.*]] = add i32 0, 1
; CHECK-NEXT:    ret i32 [[X]]
;
  br i1 undef, label %T, label %T
T:
  %X = add i32 0, 1
  ret i32 %X
}

