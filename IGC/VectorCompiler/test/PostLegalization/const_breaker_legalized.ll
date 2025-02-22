;=========================== begin_copyright_notice ============================
;
; Copyright (C) 2021-2024 Intel Corporation
;
; SPDX-License-Identifier: MIT
;
;============================ end_copyright_notice =============================

; RUN: %opt_typed_ptrs %use_old_pass_manager% -GenXPostLegalization -march=genx64 -mcpu=XeLP -mtriple=spir64 -S < %s | FileCheck %s --check-prefixes=CHECK,CHECK-TYPED-PTRS
; RUN: %opt_opaque_ptrs %use_old_pass_manager% -GenXPostLegalization -march=genx64 -mcpu=XeLP -mtriple=spir64 -S < %s | FileCheck %s --check-prefixes=CHECK,CHECK-OPAQUE-PTRS

;; Test legalization of constants as return values (constant loader).

target datalayout = "e-p:64:64-i64:64-n8:16:32"

declare void @llvm.genx.svm.scatter.v1i1.v1i64.v1i64(<1 x i1>, i32, <1 x i64>, <1 x i64>)
declare void @llvm.genx.svm.scatter.v2i1.v2i64.v2i64(<2 x i1>, i32, <2 x i64>, <2 x i64>)

declare <2 x i8*> @llvm.genx.wrregioni.v2i8.v2i8.i16.i1(<2 x i8*>, <2 x i8*>, i32, i32, i32, i16, i32, i1) readnone nounwind
declare <2 x i8*> @llvm.genx.rdregioni.v2p0i8.v2p0i8.i16(<2 x i8*>, i32, i32, i32, i16, i32) readnone nounwind

; CHECK-LABEL: @splat_test
; CHECK-TYPED-PTRS-NEXT: [[ICAST:%[^ ]+]] = inttoptr i32 1 to i16 addrspace(1)*
; CHECK-TYPED-PTRS-NEXT: [[INTVAL:%[^ ]+]] = ptrtoint i16 addrspace(1)* [[ICAST]] to i64
; CHECK-OPAQUE-PTRS-NEXT: [[ICAST:%[^ ]+]] = inttoptr i32 1 to ptr addrspace(1)
; CHECK-OPAQUE-PTRS-NEXT: [[INTVAL:%[^ ]+]] = ptrtoint ptr addrspace(1) [[ICAST]] to i64
; CHECK-NEXT: [[V1CAST:%[^ ]+]] = bitcast i64 [[INTVAL]] to <1 x i64>
; CHECK-NEXT: call void @llvm.genx.svm.scatter.v1i1.v1i64.v1i64(<1 x i1> <i1 true>, i32 0, <1 x i64> %address, <1 x i64> [[V1CAST]])
define void @splat_test(<1 x i64> %address) {
  call void @llvm.genx.svm.scatter.v1i1.v1i64.v1i64(<1 x i1> <i1 true>, i32 0, <1 x i64> %address, <1 x i64> <i64 ptrtoint (i16 addrspace(1)* inttoptr (i32 1 to i16 addrspace(1)*) to i64)>)
  ret void
}

; CHECK-LABEL: @constexpr_vect_splat
; CHECK-TYPED-PTRS-NEXT: [[ICAST:%[^ ]+]] = inttoptr i32 2 to i16 addrspace(1)*
; CHECK-TYPED-PTRS-NEXT: [[INTVAL:%[^ ]+]] = ptrtoint i16 addrspace(1)* [[ICAST]] to i64
; CHECK-OPAQUE-PTRS-NEXT: [[ICAST:%[^ ]+]] = inttoptr i32 2 to ptr addrspace(1)
; CHECK-OPAQUE-PTRS-NEXT: [[INTVAL:%[^ ]+]] = ptrtoint ptr addrspace(1) [[ICAST]] to i64
; CHECK-NEXT: [[V1CAST:%[^ ]+]] = bitcast i64 [[INTVAL]] to <1 x i64>
; CHECK-NEXT: [[SPLAT:%[^ ]+]] = call <2 x i64> @llvm.genx.rdregioni.{{[^(]+}}(<1 x i64> [[V1CAST]], i32 0, i32 1, i32 0, i16 0, i32 undef)
; CHECK-NEXT: call void @llvm.genx.svm.scatter.v2i1.v2i64.v2i64(<2 x i1> <i1 true, i1 true>, i32 0, <2 x i64> %address, <2 x i64> [[SPLAT]])
define void @constexpr_vect_splat(<2 x i64> %address) {
  call void @llvm.genx.svm.scatter.v2i1.v2i64.v2i64(<2 x i1> <i1 true, i1 true>, i32 0, <2 x i64> %address, <2 x i64> <i64 ptrtoint (i16 addrspace(1)* inttoptr (i32 2 to i16 addrspace(1)*) to i64), i64 ptrtoint (i16 addrspace(1)* inttoptr (i32 2 to i16 addrspace(1)*) to i64)>)
  ret void
}

; CHECK-LABEL: @constexpr_vect_test
; CHECK-TYPED-PTRS-NEXT: [[ICAST1:%[^ ]+]] = inttoptr i32 1 to i16 addrspace(1)*
; CHECK-TYPED-PTRS-NEXT: [[INTVAL1:%[^ ]+]] = ptrtoint i16 addrspace(1)* [[ICAST1]] to i64
; CHECK-OPAQUE-PTRS-NEXT: [[ICAST1:%[^ ]+]] = inttoptr i32 1 to ptr addrspace(1)
; CHECK-OPAQUE-PTRS-NEXT: [[INTVAL1:%[^ ]+]] = ptrtoint ptr addrspace(1) [[ICAST1]] to i64
; CHECK-TYPED-PTRS-NEXT: [[ICAST2:%[^ ]+]] = inttoptr i32 2 to i16 addrspace(1)*
; CHECK-TYPED-PTRS-NEXT: [[INTVAL2:%[^ ]+]] = ptrtoint i16 addrspace(1)* [[ICAST2]] to i64
; CHECK-OPAQUE-PTRS-NEXT: [[ICAST2:%[^ ]+]] = inttoptr i32 2 to ptr addrspace(1)
; CHECK-OPAQUE-PTRS-NEXT: [[INTVAL2:%[^ ]+]] = ptrtoint ptr addrspace(1) [[ICAST2]] to i64
; CHECK-NEXT: [[WRR1:%[^ ]+]] = call <2 x i64> @llvm.genx.wrregioni.{{[^(]+}}(<2 x i64> undef, i64 [[INTVAL1]], i32 0, i32 1, i32 1, i16 0, i32 0, i1 true)
; CHECK-NEXT: [[WRR2:%[^ ]+]] = call <2 x i64> @llvm.genx.wrregioni.{{[^(]+}}(<2 x i64> [[WRR1]], i64 [[INTVAL2]], i32 0, i32 1, i32 1, i16 8, i32 0, i1 true)
define void @constexpr_vect_test(<2 x i64> %address) {
  call void @llvm.genx.svm.scatter.v2i1.v2i64.v2i64(<2 x i1> <i1 true, i1 true>, i32 0, <2 x i64> %address, <2 x i64> <i64 ptrtoint (i16 addrspace(1)* inttoptr (i32 1 to i16 addrspace(1)*) to i64), i64 ptrtoint (i16 addrspace(1)* inttoptr (i32 2 to i16 addrspace(1)*) to i64)>)
  ret void
}

; CHECK-LABEL: @test_constptrsplat
; CHECK-TYPED-PTRS-NEXT: [[PTRCAST:%[^ ]+]] = inttoptr i32 1 to i8*
; CHECK-TYPED-PTRS-NEXT: [[PTRV1CAST:%[^ ]+]] = bitcast i8* %1 to <1 x i8*>
; CHECK-TYPED-PTRS-NEXT: [[PTRSPLAT:%[^ ]+]] = call <2 x i8*> @llvm.genx.rdregioni.v2p0i8.v1p0i8.i16(<1 x i8*> %.v1cast, i32 0, i32 1, i32 0, i16 0, i32 undef)
; CHECK-TYPED-PTRS-NEXT: [[RDR:[^ ]+]] = call <2 x i8*> @llvm.genx.rdregioni.v2p0i8.v2p0i8.i16(<2 x i8*> %.splat, i32 0, i32 1, i32 1, i16 0, i32 undef)
; CHECK-TYPED-PTRS-NEXT: ret <2 x i8*> [[RDR]]
; CHECK-OPAQUE-PTRS-NEXT: [[PTRCAST:%[^ ]+]] = inttoptr i32 1 to ptr
; CHECK-OPAQUE-PTRS-NEXT: [[PTRV1CAST:%[^ ]+]] = bitcast ptr %1 to <1 x ptr>
; CHECK-OPAQUE-PTRS-NEXT: [[PTRSPLAT:%[^ ]+]] = call <2 x ptr> @llvm.genx.rdregioni.v2p0.v1p0.i16(<1 x ptr> %.v1cast, i32 0, i32 1, i32 0, i16 0, i32 undef)
; CHECK-OPAQUE-PTRS-NEXT: [[RDR:[^ ]+]] = call <2 x ptr> @llvm.genx.rdregioni.v2p0i8.v2p0i8.i16(<2 x ptr> %.splat, i32 0, i32 1, i32 1, i16 0, i32 undef)
; CHECK-OPAQUE-PTRS-NEXT: ret <2 x ptr> [[RDR]]
define <2 x i8*> @test_constptrsplat() {
  %data = call <2 x i8*> @llvm.genx.rdregioni.v2p0i8.v2p0i8.i16(<2 x i8*> <i8 addrspace(0)* inttoptr (i32 1 to i8 addrspace(0)*), i8 addrspace(0)* inttoptr (i32 1 to i8 addrspace(0)*)>, i32 0, i32 1, i32 1, i16 0, i32 undef)
  ret <2 x i8*> %data
}

; CHECK-LABEL: @test_constexpr_ptrvect
; CHECK-TYPED-PTRS-NEXT: [[PTRCAST1:%[^ ]+]] = inttoptr i32 2 to i8*
; CHECK-TYPED-PTRS-NEXT: [[PTRCAST2:%[^ ]+]] = inttoptr i32 1 to i8*
; CHECK-TYPED-PTRS-NEXT: [[WRR1:%[^ ]+]] = call <2 x i8*> @llvm.genx.wrregioni.v2p0i8.p0i8.i16.i1(<2 x i8*> undef, i8* [[PTRCAST1]], i32 0, i32 1, i32 1, i16 0, i32 0, i1 true)
; CHECK-TYPED-PTRS-NEXT: [[WRR2:%[^ ]+]] = call <2 x i8*> @llvm.genx.wrregioni.v2p0i8.p0i8.i16.i1(<2 x i8*> [[WRR1]], i8* [[PTRCAST2]], i32 0, i32 1, i32 1, i16 8, i32 0, i1 true)
; CHECK-TYPED-PTRS-NEXT: [[RESULT:%[^ ]+]] = call <2 x i8*> @llvm.genx.rdregioni.v2p0i8.v2p0i8.i16(<2 x i8*> [[WRR2]], i32 0, i32 1, i32 1, i16 0, i32 undef)
; CHECK-TYPED-PTRS-NEXT: ret <2 x i8*> [[RESULT]]
; CHECK-OPAQUE-PTRS-NEXT: [[PTRCAST1:%[^ ]+]] = inttoptr i32 2 to ptr
; CHECK-OPAQUE-PTRS-NEXT: [[PTRCAST2:%[^ ]+]] = inttoptr i32 1 to ptr
; CHECK-OPAQUE-PTRS-NEXT: [[WRR1:%[^ ]+]] = call <2 x ptr> @llvm.genx.wrregioni.v2p0.p0.i16.i1(<2 x ptr> undef, ptr [[PTRCAST1]], i32 0, i32 1, i32 1, i16 0, i32 0, i1 true)
; CHECK-OPAQUE-PTRS-NEXT: [[WRR2:%[^ ]+]] = call <2 x ptr> @llvm.genx.wrregioni.v2p0.p0.i16.i1(<2 x ptr> [[WRR1]], ptr [[PTRCAST2]], i32 0, i32 1, i32 1, i16 8, i32 0, i1 true)
; CHECK-OPAQUE-PTRS-NEXT: [[RESULT:%[^ ]+]] = call <2 x ptr> @llvm.genx.rdregioni.v2p0i8.v2p0i8.i16(<2 x ptr> [[WRR2]], i32 0, i32 1, i32 1, i16 0, i32 undef)
; CHECK-OPAQUE-PTRS-NEXT: ret <2 x ptr> [[RESULT]]
define <2 x i8*> @test_constexpr_ptrvect() {
  %data = call <2 x i8*> @llvm.genx.rdregioni.v2p0i8.v2p0i8.i16(<2 x i8*> <i8 addrspace(0)* inttoptr (i32 2 to i8 addrspace(0)*), i8 addrspace(0)* inttoptr (i32 1 to i8 addrspace(0)*)>, i32 0, i32 1, i32 1, i16 0, i32 undef)
  ret <2 x i8*> %data
}

; CHECK-LABEL: @test_constexpr_phi
; CHECK-NEXT: BB1:
; CHECK-TYPED-PTRS-NEXT: [[PTRCAST1:%[^ ]+]] = inttoptr i32 1 to i8*
; CHECK-OPAQUE-PTRS-NEXT: [[PTRCAST1:%[^ ]+]] = inttoptr i32 1 to ptr
; CHECK-NEXT: br i1 %cond, label %BB2, label %BB3
; CHECK: BB2:
; CHECK-TYPED-PTRS-NEXT: [[PTRCAST2:%[^ ]+]] = inttoptr i32 2 to i8*
; CHECK-OPAQUE-PTRS-NEXT: [[PTRCAST2:%[^ ]+]] = inttoptr i32 2 to ptr
; CHECK-NEXT: br label %BB3
; CHECK: BB3:
; CHECK-TYPED-PTRS-NEXT: [[RESULT:%[^ ]+]] = phi i8* [ [[PTRCAST1]], %BB1 ], [ [[PTRCAST2]], %BB2 ]
; CHECK-TYPED-PTRS-NEXT: ret i8* [[RESULT]]
; CHECK-OPAQUE-PTRS-NEXT: [[RESULT:%[^ ]+]] = phi ptr [ [[PTRCAST1]], %BB1 ], [ [[PTRCAST2]], %BB2 ]
; CHECK-OPAQUE-PTRS-NEXT: ret ptr [[RESULT]]
define i8* @test_constexpr_phi(i1 %cond) {
BB1:
  br i1 %cond, label %BB2, label %BB3

BB2:
  br label %BB3

BB3:
  %phi = phi i8* [ inttoptr (i32 1 to i8 addrspace(0)*), %BB1 ], [ inttoptr (i32 2 to i8 addrspace(0)*), %BB2 ]
  ret i8* %phi
}
