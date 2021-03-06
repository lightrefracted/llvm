; RUN: llc < %s -march=r600 -mcpu=SI  | FileCheck %s

; This test checks that no VGPR to SGPR copies are created by the register
; allocator.
; CHECK-LABEL: @phi1
; CHECK: S_BUFFER_LOAD_DWORD [[DST:s[0-9]]], {{s\[[0-9]+:[0-9]+\]}}, 0
; CHECK: V_MOV_B32_e32 v{{[0-9]}}, [[DST]]

define void @phi1(<16 x i8> addrspace(2)* inreg, <16 x i8> addrspace(2)* inreg, <32 x i8> addrspace(2)* inreg, i32 inreg, <2 x i32>, <2 x i32>, <2 x i32>, <3 x i32>, <2 x i32>, <2 x i32>, <2 x i32>, float, float, float, float, float, float, float, float, float) #0 {
main_body:
  %20 = getelementptr <16 x i8> addrspace(2)* %0, i32 0
  %21 = load <16 x i8> addrspace(2)* %20, !tbaa !1
  %22 = call float @llvm.SI.load.const(<16 x i8> %21, i32 0)
  %23 = call float @llvm.SI.load.const(<16 x i8> %21, i32 16)
  %24 = call float @llvm.SI.load.const(<16 x i8> %21, i32 32)
  %25 = fptosi float %23 to i32
  %26 = icmp ne i32 %25, 0
  br i1 %26, label %ENDIF, label %ELSE

ELSE:                                             ; preds = %main_body
  %27 = fsub float -0.000000e+00, %22
  br label %ENDIF

ENDIF:                                            ; preds = %main_body, %ELSE
  %temp.0 = phi float [ %27, %ELSE ], [ %22, %main_body ]
  %28 = fadd float %temp.0, %24
  call void @llvm.SI.export(i32 15, i32 1, i32 1, i32 0, i32 0, float %28, float %28, float 0.000000e+00, float 1.000000e+00)
  ret void
}

; Make sure this program doesn't crash
; CHECK-LABEL: @phi2
define void @phi2(<16 x i8> addrspace(2)* inreg, <16 x i8> addrspace(2)* inreg, <32 x i8> addrspace(2)* inreg, i32 inreg, <2 x i32>, <2 x i32>, <2 x i32>, <3 x i32>, <2 x i32>, <2 x i32>, <2 x i32>, float, float, float, float, float, float, float, float, float) #0 {
main_body:
  %20 = getelementptr <16 x i8> addrspace(2)* %0, i32 0
  %21 = load <16 x i8> addrspace(2)* %20, !tbaa !1
  %22 = call float @llvm.SI.load.const(<16 x i8> %21, i32 16)
  %23 = call float @llvm.SI.load.const(<16 x i8> %21, i32 32)
  %24 = call float @llvm.SI.load.const(<16 x i8> %21, i32 36)
  %25 = call float @llvm.SI.load.const(<16 x i8> %21, i32 40)
  %26 = call float @llvm.SI.load.const(<16 x i8> %21, i32 48)
  %27 = call float @llvm.SI.load.const(<16 x i8> %21, i32 52)
  %28 = call float @llvm.SI.load.const(<16 x i8> %21, i32 56)
  %29 = call float @llvm.SI.load.const(<16 x i8> %21, i32 64)
  %30 = call float @llvm.SI.load.const(<16 x i8> %21, i32 68)
  %31 = call float @llvm.SI.load.const(<16 x i8> %21, i32 72)
  %32 = call float @llvm.SI.load.const(<16 x i8> %21, i32 76)
  %33 = call float @llvm.SI.load.const(<16 x i8> %21, i32 80)
  %34 = call float @llvm.SI.load.const(<16 x i8> %21, i32 84)
  %35 = call float @llvm.SI.load.const(<16 x i8> %21, i32 88)
  %36 = call float @llvm.SI.load.const(<16 x i8> %21, i32 92)
  %37 = getelementptr <32 x i8> addrspace(2)* %2, i32 0
  %38 = load <32 x i8> addrspace(2)* %37, !tbaa !1
  %39 = getelementptr <16 x i8> addrspace(2)* %1, i32 0
  %40 = load <16 x i8> addrspace(2)* %39, !tbaa !1
  %41 = call float @llvm.SI.fs.interp(i32 0, i32 0, i32 %3, <2 x i32> %5)
  %42 = call float @llvm.SI.fs.interp(i32 1, i32 0, i32 %3, <2 x i32> %5)
  %43 = call float @llvm.SI.fs.interp(i32 0, i32 1, i32 %3, <2 x i32> %5)
  %44 = call float @llvm.SI.fs.interp(i32 1, i32 1, i32 %3, <2 x i32> %5)
  %45 = call float @llvm.SI.fs.interp(i32 2, i32 1, i32 %3, <2 x i32> %5)
  %46 = bitcast float %41 to i32
  %47 = bitcast float %42 to i32
  %48 = insertelement <2 x i32> undef, i32 %46, i32 0
  %49 = insertelement <2 x i32> %48, i32 %47, i32 1
  %50 = call <4 x float> @llvm.SI.sample.v2i32(<2 x i32> %49, <32 x i8> %38, <16 x i8> %40, i32 2)
  %51 = extractelement <4 x float> %50, i32 2
  %52 = call float @fabs(float %51)
  %53 = fmul float %43, %43
  %54 = fmul float %44, %44
  %55 = fadd float %54, %53
  %56 = fmul float %45, %45
  %57 = fadd float %55, %56
  %58 = call float @llvm.AMDGPU.rsq(float %57)
  %59 = fmul float %43, %58
  %60 = fmul float %44, %58
  %61 = fmul float %45, %58
  %62 = fmul float %59, %23
  %63 = fmul float %60, %24
  %64 = fadd float %63, %62
  %65 = fmul float %61, %25
  %66 = fadd float %64, %65
  %67 = fsub float -0.000000e+00, %26
  %68 = fmul float %66, %52
  %69 = fadd float %68, %67
  %70 = fmul float %27, %69
  %71 = fmul float %28, %69
  %72 = call float @fabs(float %70)
  %73 = fcmp olt float 0x3EE4F8B580000000, %72
  %74 = sext i1 %73 to i32
  %75 = bitcast i32 %74 to float
  %76 = bitcast float %75 to i32
  %77 = icmp ne i32 %76, 0
  br i1 %77, label %IF, label %ENDIF

IF:                                               ; preds = %main_body
  %78 = fsub float -0.000000e+00, %70
  %79 = call float @llvm.AMDIL.exp.(float %78)
  %80 = fsub float -0.000000e+00, %79
  %81 = fadd float 1.000000e+00, %80
  %82 = fdiv float 1.000000e+00, %70
  %83 = fmul float %81, %82
  %84 = fmul float %32, %83
  br label %ENDIF

ENDIF:                                            ; preds = %main_body, %IF
  %temp4.0 = phi float [ %84, %IF ], [ %32, %main_body ]
  %85 = call float @fabs(float %71)
  %86 = fcmp olt float 0x3EE4F8B580000000, %85
  %87 = sext i1 %86 to i32
  %88 = bitcast i32 %87 to float
  %89 = bitcast float %88 to i32
  %90 = icmp ne i32 %89, 0
  br i1 %90, label %IF25, label %ENDIF24

IF25:                                             ; preds = %ENDIF
  %91 = fsub float -0.000000e+00, %71
  %92 = call float @llvm.AMDIL.exp.(float %91)
  %93 = fsub float -0.000000e+00, %92
  %94 = fadd float 1.000000e+00, %93
  %95 = fdiv float 1.000000e+00, %71
  %96 = fmul float %94, %95
  %97 = fmul float %36, %96
  br label %ENDIF24

ENDIF24:                                          ; preds = %ENDIF, %IF25
  %temp8.0 = phi float [ %97, %IF25 ], [ %36, %ENDIF ]
  %98 = fmul float %29, %temp4.0
  %99 = fmul float %30, %temp4.0
  %100 = fmul float %31, %temp4.0
  %101 = fmul float %33, %temp8.0
  %102 = fadd float %101, %98
  %103 = fmul float %34, %temp8.0
  %104 = fadd float %103, %99
  %105 = fmul float %35, %temp8.0
  %106 = fadd float %105, %100
  %107 = call float @llvm.pow.f32(float %52, float %22)
  %108 = fsub float -0.000000e+00, %102
  %109 = fmul float %108, %107
  %110 = fsub float -0.000000e+00, %104
  %111 = fmul float %110, %107
  %112 = fsub float -0.000000e+00, %106
  %113 = fmul float %112, %107
  %114 = call i32 @llvm.SI.packf16(float %109, float %111)
  %115 = bitcast i32 %114 to float
  %116 = call i32 @llvm.SI.packf16(float %113, float 1.000000e+00)
  %117 = bitcast i32 %116 to float
  call void @llvm.SI.export(i32 15, i32 1, i32 1, i32 0, i32 1, float %115, float %117, float %115, float %117)
  ret void
}

; We just want ot make sure the program doesn't crash
; CHECK-LABEL: @loop

define void @loop(<16 x i8> addrspace(2)* inreg, <16 x i8> addrspace(2)* inreg, <32 x i8> addrspace(2)* inreg, i32 inreg, <2 x i32>, <2 x i32>, <2 x i32>, <3 x i32>, <2 x i32>, <2 x i32>, <2 x i32>, float, float, float, float, float, float, float, float, float) #0 {
main_body:
  %20 = getelementptr <16 x i8> addrspace(2)* %0, i32 0
  %21 = load <16 x i8> addrspace(2)* %20, !tbaa !1
  %22 = call float @llvm.SI.load.const(<16 x i8> %21, i32 0)
  %23 = call float @llvm.SI.load.const(<16 x i8> %21, i32 4)
  %24 = call float @llvm.SI.load.const(<16 x i8> %21, i32 8)
  %25 = call float @llvm.SI.load.const(<16 x i8> %21, i32 12)
  %26 = fptosi float %25 to i32
  %27 = bitcast i32 %26 to float
  %28 = bitcast float %27 to i32
  br label %LOOP

LOOP:                                             ; preds = %ENDIF, %main_body
  %temp4.0 = phi float [ %22, %main_body ], [ %temp5.0, %ENDIF ]
  %temp5.0 = phi float [ %23, %main_body ], [ %temp6.0, %ENDIF ]
  %temp6.0 = phi float [ %24, %main_body ], [ %temp4.0, %ENDIF ]
  %temp8.0 = phi float [ 0.000000e+00, %main_body ], [ %37, %ENDIF ]
  %29 = bitcast float %temp8.0 to i32
  %30 = icmp sge i32 %29, %28
  %31 = sext i1 %30 to i32
  %32 = bitcast i32 %31 to float
  %33 = bitcast float %32 to i32
  %34 = icmp ne i32 %33, 0
  br i1 %34, label %IF, label %ENDIF

IF:                                               ; preds = %LOOP
  call void @llvm.SI.export(i32 15, i32 1, i32 1, i32 0, i32 0, float %temp4.0, float %temp5.0, float %temp6.0, float 1.000000e+00)
  ret void

ENDIF:                                            ; preds = %LOOP
  %35 = bitcast float %temp8.0 to i32
  %36 = add i32 %35, 1
  %37 = bitcast i32 %36 to float
  br label %LOOP
}

; Function Attrs: nounwind readnone
declare float @llvm.SI.load.const(<16 x i8>, i32) #1

; Function Attrs: readonly
declare float @fabs(float) #2

declare void @llvm.SI.export(i32, i32, i32, i32, i32, float, float, float, float)

attributes #0 = { "ShaderType"="0" }
attributes #1 = { nounwind readnone }
attributes #2 = { readonly }
attributes #3 = { readnone }
attributes #4 = { nounwind readonly }

!0 = metadata !{metadata !"const", null}
!1 = metadata !{metadata !0, metadata !0, i64 0, i32 1}

; Function Attrs: nounwind readnone
declare float @llvm.SI.fs.interp(i32, i32, i32, <2 x i32>) #1

; Function Attrs: nounwind readnone
declare <4 x float> @llvm.SI.sample.v2i32(<2 x i32>, <32 x i8>, <16 x i8>, i32) #1

; Function Attrs: readnone
declare float @llvm.AMDGPU.rsq(float) #3

; Function Attrs: readnone
declare float @llvm.AMDIL.exp.(float) #3

; Function Attrs: nounwind readonly
declare float @llvm.pow.f32(float, float) #4

; Function Attrs: nounwind readnone
declare i32 @llvm.SI.packf16(float, float) #1
