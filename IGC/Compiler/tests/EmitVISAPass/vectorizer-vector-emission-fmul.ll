; UNSUPPORTED: system-windows
; REQUIRES: pvc-supported, regkeys

; RUN: igc_opt -S -dce -platformpvc -rev-id B -has-emulated-64-bit-insts -igc-emit-visa --regkey=DumpVISAASMToConsole=1 -simd-mode 16 < %s | FileCheck %s

; CHECK: .decl vectorized_phi v_type=G type=f num_elts=128 align=wordx32
; CHECK: .decl vector v_type=G type=f num_elts=8 align=dword

; CHECK: mul (M1, 16) vectorized_phi(0,0)<1> vector(0,0)<0;1,0> vectorized_phi(0,0)<1;1,0>
; CHECK: mul (M1, 16) vectorized_phi(1,0)<1> vector(0,1)<0;1,0> vectorized_phi(1,0)<1;1,0>
; CHECK: mul (M1, 16) vectorized_phi(2,0)<1> vector(0,2)<0;1,0> vectorized_phi(2,0)<1;1,0>
; CHECK: mul (M1, 16) vectorized_phi(3,0)<1> vector(0,3)<0;1,0> vectorized_phi(3,0)<1;1,0>
; CHECK: mul (M1, 16) vectorized_phi(4,0)<1> vector(0,4)<0;1,0> vectorized_phi(4,0)<1;1,0>
; CHECK: mul (M1, 16) vectorized_phi(5,0)<1> vector(0,5)<0;1,0> vectorized_phi(5,0)<1;1,0>
; CHECK: mul (M1, 16) vectorized_phi(6,0)<1> vector(0,6)<0;1,0> vectorized_phi(6,0)<1;1,0>
; CHECK: mul (M1, 16) vectorized_phi(7,0)<1> vector(0,7)<0;1,0> vectorized_phi(7,0)<1;1,0>


define spir_kernel void @_attn_fwd(half addrspace(1)* %0, half addrspace(1)* %1, half addrspace(1)* %2, float %3, i8 addrspace(1)* %4, float addrspace(1)* %5, <8 x i32> %r0, <8 x i32> %payloadHeader, i8* %privateBase, i32 %bufferOffset, i32 %bufferOffset1, i32 %bufferOffset2, i32 %bufferOffset3, i32 %bufferOffset4) {
  br label %._crit_edge

._crit_edge:                                      ; preds = %._crit_edge.._crit_edge_crit_edge, %6
  %7 = phi float [ 0.000000e+00, %6 ], [ %7, %._crit_edge.._crit_edge_crit_edge ]
  %vectorized_phi = phi <8 x float> [ zeroinitializer, %6 ], [ %8, %._crit_edge.._crit_edge_crit_edge ]
  %vector = insertelement <8 x float> zeroinitializer, float 0.000000e+00, i64 0
  %vectorized_binary = fmul <8 x float> %vector, %vectorized_phi
  %8 = call <8 x float> @llvm.genx.GenISA.sub.group.dpas.v8f32.v8f32.v8i16.v8i32(<8 x float> %vectorized_binary, <8 x i16> zeroinitializer, <8 x i32> zeroinitializer, i32 0, i32 0, i32 0, i32 0, i1 false)
  br label %._crit_edge.._crit_edge_crit_edge

._crit_edge.._crit_edge_crit_edge:                ; preds = %._crit_edge
  br label %._crit_edge
}

declare <8 x float> @llvm.genx.GenISA.sub.group.dpas.v8f32.v8f32.v8i16.v8i32(<8 x float>, <8 x i16>, <8 x i32>, i32, i32, i32, i32, i1)

!igc.functions = !{!0}
!IGCMetadata = !{!19}

!0 = !{void (half addrspace(1)*, half addrspace(1)*, half addrspace(1)*, float, i8 addrspace(1)*, float addrspace(1)*, <8 x i32>, <8 x i32>, i8*, i32, i32, i32, i32, i32)* @_attn_fwd, !1}
!1 = !{!2, !3, !17, !18}
!2 = !{!"function_type", i32 0}
!3 = !{!"implicit_arg_desc", !4, !5, !6, !7, !9, !11, !13, !15}
!4 = !{i32 0}
!5 = !{i32 1}
!6 = !{i32 12}
!7 = !{i32 14, !8}
!8 = !{!"explicit_arg_num", i32 0}
!9 = !{i32 14, !10}
!10 = !{!"explicit_arg_num", i32 1}
!11 = !{i32 14, !12}
!12 = !{!"explicit_arg_num", i32 2}
!13 = !{i32 14, !14}
!14 = !{!"explicit_arg_num", i32 4}
!15 = !{i32 14, !16}
!16 = !{!"explicit_arg_num", i32 5}
!17 = !{!"sub_group_size", i32 16}
!18 = !{!"max_reg_pressure", i32 185}
!19 = !{!"ModuleMD", !20, !21, !126, !247, !278, !281, !282, !286, !289, !290, !291, !327, !353, !366, !367, !368, !384, !385, !386, !387, !388, !389, !390, !391, !392, !393, !397, !398, !405, !406, !407, !408, !409, !410, !411, !412, !413, !414, !415, !416, !418, !422, !423, !424, !425, !426, !427, !428, !429, !430, !431, !432, !433, !434, !435, !436, !437, !438, !439, !440, !191, !441, !444, !445, !447, !450, !451, !452, !454, !455, !456, !461, !462}
!20 = !{!"isPrecise", i1 false}
!21 = !{!"compOpt", !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45, !46, !47, !48, !49, !50, !51, !52, !53, !54, !55, !56, !57, !58, !59, !60, !61, !62, !63, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !95, !96, !97, !98, !99, !100, !101, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !117, !118, !119, !120, !121, !122, !123, !124, !125}
!22 = !{!"DenormsAreZero", i1 false}
!23 = !{!"BFTFDenormsAreZero", i1 false}
!24 = !{!"CorrectlyRoundedDivSqrt", i1 false}
!25 = !{!"OptDisable", i1 false}
!26 = !{!"MadEnable", i1 false}
!27 = !{!"NoSignedZeros", i1 false}
!28 = !{!"NoNaNs", i1 false}
!29 = !{!"FloatRoundingMode", i32 0}
!30 = !{!"FloatCvtIntRoundingMode", i32 3}
!31 = !{!"LoadCacheDefault", i32 4}
!32 = !{!"StoreCacheDefault", i32 2}
!33 = !{!"VISAPreSchedRPThreshold", i32 0}
!34 = !{!"SetLoopUnrollThreshold", i32 0}
!35 = !{!"UnsafeMathOptimizations", i1 false}
!36 = !{!"disableCustomUnsafeOpts", i1 false}
!37 = !{!"disableReducePow", i1 false}
!38 = !{!"disableSqrtOpt", i1 false}
!39 = !{!"FiniteMathOnly", i1 false}
!40 = !{!"FastRelaxedMath", i1 false}
!41 = !{!"DashGSpecified", i1 false}
!42 = !{!"FastCompilation", i1 false}
!43 = !{!"UseScratchSpacePrivateMemory", i1 true}
!44 = !{!"RelaxedBuiltins", i1 false}
!45 = !{!"SubgroupIndependentForwardProgressRequired", i1 true}
!46 = !{!"GreaterThan2GBBufferRequired", i1 true}
!47 = !{!"GreaterThan4GBBufferRequired", i1 true}
!48 = !{!"DisableA64WA", i1 false}
!49 = !{!"ForceEnableA64WA", i1 false}
!50 = !{!"PushConstantsEnable", i1 true}
!51 = !{!"HasPositivePointerOffset", i1 false}
!52 = !{!"HasBufferOffsetArg", i1 true}
!53 = !{!"BufferOffsetArgOptional", i1 true}
!54 = !{!"replaceGlobalOffsetsByZero", i1 false}
!55 = !{!"forcePixelShaderSIMDMode", i32 0}
!56 = !{!"ForceGeomFFShaderSIMDMode", i32 0}
!57 = !{!"pixelShaderDoNotAbortOnSpill", i1 false}
!58 = !{!"UniformWGS", i1 false}
!59 = !{!"disableVertexComponentPacking", i1 false}
!60 = !{!"disablePartialVertexComponentPacking", i1 false}
!61 = !{!"PreferBindlessImages", i1 false}
!62 = !{!"UseBindlessMode", i1 false}
!63 = !{!"UseLegacyBindlessMode", i1 true}
!64 = !{!"disableMathRefactoring", i1 false}
!65 = !{!"atomicBranch", i1 false}
!66 = !{!"spillCompression", i1 false}
!67 = !{!"DisableEarlyOut", i1 false}
!68 = !{!"ForceInt32DivRemEmu", i1 false}
!69 = !{!"ForceInt32DivRemEmuSP", i1 false}
!70 = !{!"WaveIntrinsicUsed", i1 false}
!71 = !{!"DisableMultiPolyPS", i1 false}
!72 = !{!"NeedTexture3DLODWA", i1 false}
!73 = !{!"DisableFastestSingleCSSIMD", i1 false}
!74 = !{!"DisableFastestLinearScan", i1 false}
!75 = !{!"UseStatelessforPrivateMemory", i1 false}
!76 = !{!"EnableTakeGlobalAddress", i1 false}
!77 = !{!"IsLibraryCompilation", i1 false}
!78 = !{!"LibraryCompileSIMDSize", i32 0}
!79 = !{!"FastVISACompile", i1 false}
!80 = !{!"MatchSinCosPi", i1 false}
!81 = !{!"ExcludeIRFromZEBinary", i1 false}
!82 = !{!"EmitZeBinVISASections", i1 false}
!83 = !{!"FP64GenEmulationEnabled", i1 false}
!84 = !{!"FP64GenConvEmulationEnabled", i1 false}
!85 = !{!"allowDisableRematforCS", i1 false}
!86 = !{!"DisableIncSpillCostAllAddrTaken", i1 false}
!87 = !{!"DisableCPSOmaskWA", i1 false}
!88 = !{!"DisableFastestGopt", i1 false}
!89 = !{!"WaForceHalfPromotionComputeShader", i1 false}
!90 = !{!"WaForceHalfPromotionPixelVertexShader", i1 false}
!91 = !{!"DisableConstantCoalescing", i1 false}
!92 = !{!"EnableUndefAlphaOutputAsRed", i1 true}
!93 = !{!"WaEnableALTModeVisaWA", i1 false}
!94 = !{!"EnableLdStCombineforLoad", i1 false}
!95 = !{!"EnableLdStCombinewithDummyLoad", i1 false}
!96 = !{!"WaEnableAtomicWaveFusion", i1 false}
!97 = !{!"WaEnableAtomicWaveFusionNonNullResource", i1 false}
!98 = !{!"WaEnableAtomicWaveFusionStateless", i1 false}
!99 = !{!"WaEnableAtomicWaveFusionTyped", i1 false}
!100 = !{!"WaEnableAtomicWaveFusionPartial", i1 false}
!101 = !{!"WaEnableAtomicWaveFusionMoreDimensions", i1 false}
!103 = !{!"WaStoreRawVectorToTypedWrite", i1 false}
!104 = !{!"WaLoadRawVectorToTypedRead", i1 false}
!105 = !{!"WaZeroSLMBeforeUse", i1 false}
!106 = !{!"WaFlagGroupTypedUAVGloballyCoherent", i1 false}
!107 = !{!"EnableFastSampleD", i1 false}
!108 = !{!"NewSpillCostFunction", i1 false}
!109 = !{!"EnableVRT", i1 false}
!110 = !{!"ForceLargeGRFNum4RQ", i1 false}
!111 = !{!"Enable2xGRFRetry", i1 false}
!112 = !{!"Detect2xGRFCandidate", i1 false}
!113 = !{!"EnableURBWritesMerging", i1 true}
!114 = !{!"DisableEUFusion", i1 false}
!115 = !{!"DisableFDivToFMulInvOpt", i1 false}
!116 = !{!"initializePhiSampleSourceWA", i1 false}
!117 = !{!"WaDisableSubspanUseNoMaskForCB", i1 false}
!118 = !{!"DisableLoosenSimd32Occu", i1 false}
!119 = !{!"FastestS1Options", i32 0}
!120 = !{!"DisableFastestForWaveIntrinsicsCS", i1 false}
!121 = !{!"ForceLinearWalkOnLinearUAV", i1 false}
!122 = !{!"DisableLscSamplerRouting", i1 false}
!123 = !{!"UseBarrierControlFlowOptimization", i1 false}
!124 = !{!"disableDynamicRQManagement", i1 false}
!125 = !{!"Quad8InputThreshold", i32 0}
!126 = !{!"FuncMD", !127, !128}
!127 = !{!"FuncMDMap[0]", void (half addrspace(1)*, half addrspace(1)*, half addrspace(1)*, float, i8 addrspace(1)*, float addrspace(1)*, <8 x i32>, <8 x i32>, i8*, i32, i32, i32, i32, i32)* @_attn_fwd}
!128 = !{!"FuncMDValue[0]", !129, !130, !134, !135, !136, !137, !138, !139, !140, !160, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194, !195, !196, !197, !198, !199, !206, !213, !220, !227, !234, !241, !242, !246}
!129 = !{!"localOffsets"}
!130 = !{!"workGroupWalkOrder", !131, !132, !133}
!131 = !{!"dim0", i32 0}
!132 = !{!"dim1", i32 1}
!133 = !{!"dim2", i32 2}
!134 = !{!"funcArgs"}
!135 = !{!"functionType", !"KernelFunction"}
!136 = !{!"inlineDynConstants"}
!137 = !{!"inlineDynRootConstant"}
!138 = !{!"inlineDynConstantDescTable"}
!139 = !{!"m_pInterestingConstants"}
!140 = !{!"rtInfo", !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151, !152, !153, !154, !155, !156, !158, !159, !109}
!141 = !{!"callableShaderType", !"NumberOfCallableShaderTypes"}
!142 = !{!"isContinuation", i1 false}
!143 = !{!"hasTraceRayPayload", i1 false}
!144 = !{!"hasHitAttributes", i1 false}
!145 = !{!"hasCallableData", i1 false}
!146 = !{!"ShaderStackSize", i32 0}
!147 = !{!"ShaderHash", i64 0}
!148 = !{!"ShaderName", !""}
!149 = !{!"ParentName", !""}
!150 = !{!"SlotNum", i1* null}
!151 = !{!"NOSSize", i32 0}
!152 = !{!"globalRootSignatureSize", i32 0}
!153 = !{!"Entries"}
!154 = !{!"SpillUnions"}
!155 = !{!"CustomHitAttrSizeInBytes", i32 0}
!156 = !{!"Types", !157}
!157 = !{!"FullFrameTys"}
!158 = !{!"Aliases"}
!159 = !{!"NumGRF", i32 0}
!160 = !{!"resAllocMD", !161, !162, !163, !164, !182}
!161 = !{!"uavsNumType", i32 0}
!162 = !{!"srvsNumType", i32 0}
!163 = !{!"samplersNumType", i32 0}
!164 = !{!"argAllocMDList", !165, !169, !170, !171, !172, !173, !174, !175, !176, !177, !178, !179, !180, !181}
!165 = !{!"argAllocMDListVec[0]", !166, !167, !168}
!166 = !{!"type", i32 0}
!167 = !{!"extensionType", i32 -1}
!168 = !{!"indexType", i32 -1}
!169 = !{!"argAllocMDListVec[1]", !166, !167, !168}
!170 = !{!"argAllocMDListVec[2]", !166, !167, !168}
!171 = !{!"argAllocMDListVec[3]", !166, !167, !168}
!172 = !{!"argAllocMDListVec[4]", !166, !167, !168}
!173 = !{!"argAllocMDListVec[5]", !166, !167, !168}
!174 = !{!"argAllocMDListVec[6]", !166, !167, !168}
!175 = !{!"argAllocMDListVec[7]", !166, !167, !168}
!176 = !{!"argAllocMDListVec[8]", !166, !167, !168}
!177 = !{!"argAllocMDListVec[9]", !166, !167, !168}
!178 = !{!"argAllocMDListVec[10]", !166, !167, !168}
!179 = !{!"argAllocMDListVec[11]", !166, !167, !168}
!180 = !{!"argAllocMDListVec[12]", !166, !167, !168}
!181 = !{!"argAllocMDListVec[13]", !166, !167, !168}
!182 = !{!"inlineSamplersMD"}
!183 = !{!"maxByteOffsets"}
!184 = !{!"IsInitializer", i1 false}
!185 = !{!"IsFinalizer", i1 false}
!186 = !{!"CompiledSubGroupsNumber", i32 0}
!187 = !{!"hasInlineVmeSamplers", i1 false}
!188 = !{!"localSize", i32 0}
!189 = !{!"localIDPresent", i1 false}
!190 = !{!"groupIDPresent", i1 false}
!191 = !{!"privateMemoryPerWI", i32 0}
!192 = !{!"prevFPOffset", i32 0}
!193 = !{!"globalIDPresent", i1 false}
!194 = !{!"hasSyncRTCalls", i1 false}
!195 = !{!"hasNonKernelArgLoad", i1 false}
!196 = !{!"hasNonKernelArgStore", i1 false}
!197 = !{!"hasNonKernelArgAtomic", i1 false}
!198 = !{!"UserAnnotations"}
!199 = !{!"m_OpenCLArgAddressSpaces", !200, !201, !202, !203, !204, !205}
!200 = !{!"m_OpenCLArgAddressSpacesVec[0]", i32 1}
!201 = !{!"m_OpenCLArgAddressSpacesVec[1]", i32 1}
!202 = !{!"m_OpenCLArgAddressSpacesVec[2]", i32 1}
!203 = !{!"m_OpenCLArgAddressSpacesVec[3]", i32 0}
!204 = !{!"m_OpenCLArgAddressSpacesVec[4]", i32 1}
!205 = !{!"m_OpenCLArgAddressSpacesVec[5]", i32 1}
!206 = !{!"m_OpenCLArgAccessQualifiers", !207, !208, !209, !210, !211, !212}
!207 = !{!"m_OpenCLArgAccessQualifiersVec[0]", !"none"}
!208 = !{!"m_OpenCLArgAccessQualifiersVec[1]", !"none"}
!209 = !{!"m_OpenCLArgAccessQualifiersVec[2]", !"none"}
!210 = !{!"m_OpenCLArgAccessQualifiersVec[3]", !"none"}
!211 = !{!"m_OpenCLArgAccessQualifiersVec[4]", !"none"}
!212 = !{!"m_OpenCLArgAccessQualifiersVec[5]", !"none"}
!213 = !{!"m_OpenCLArgTypes", !214, !215, !216, !217, !218, !219}
!214 = !{!"m_OpenCLArgTypesVec[0]", !"half*"}
!215 = !{!"m_OpenCLArgTypesVec[1]", !"half*"}
!216 = !{!"m_OpenCLArgTypesVec[2]", !"half*"}
!217 = !{!"m_OpenCLArgTypesVec[3]", !"float"}
!218 = !{!"m_OpenCLArgTypesVec[4]", !"char*"}
!219 = !{!"m_OpenCLArgTypesVec[5]", !"float*"}
!220 = !{!"m_OpenCLArgBaseTypes", !221, !222, !223, !224, !225, !226}
!221 = !{!"m_OpenCLArgBaseTypesVec[0]", !"half*"}
!222 = !{!"m_OpenCLArgBaseTypesVec[1]", !"half*"}
!223 = !{!"m_OpenCLArgBaseTypesVec[2]", !"half*"}
!224 = !{!"m_OpenCLArgBaseTypesVec[3]", !"float"}
!225 = !{!"m_OpenCLArgBaseTypesVec[4]", !"char*"}
!226 = !{!"m_OpenCLArgBaseTypesVec[5]", !"float*"}
!227 = !{!"m_OpenCLArgTypeQualifiers", !228, !229, !230, !231, !232, !233}
!228 = !{!"m_OpenCLArgTypeQualifiersVec[0]", !""}
!229 = !{!"m_OpenCLArgTypeQualifiersVec[1]", !""}
!230 = !{!"m_OpenCLArgTypeQualifiersVec[2]", !""}
!231 = !{!"m_OpenCLArgTypeQualifiersVec[3]", !""}
!232 = !{!"m_OpenCLArgTypeQualifiersVec[4]", !""}
!233 = !{!"m_OpenCLArgTypeQualifiersVec[5]", !""}
!234 = !{!"m_OpenCLArgNames", !235, !236, !237, !238, !239, !240}
!235 = !{!"m_OpenCLArgNamesVec[0]", !""}
!236 = !{!"m_OpenCLArgNamesVec[1]", !""}
!237 = !{!"m_OpenCLArgNamesVec[2]", !""}
!238 = !{!"m_OpenCLArgNamesVec[3]", !""}
!239 = !{!"m_OpenCLArgNamesVec[4]", !""}
!240 = !{!"m_OpenCLArgNamesVec[5]", !""}
!241 = !{!"m_OpenCLArgScalarAsPointers"}
!242 = !{!"m_OptsToDisablePerFunc", !243, !244, !245}
!243 = !{!"m_OptsToDisablePerFuncSet[0]", !"IGC-AddressArithmeticSinking"}
!244 = !{!"m_OptsToDisablePerFuncSet[1]", !"IGC-AllowSimd32Slicing"}
!245 = !{!"m_OptsToDisablePerFuncSet[2]", !"IGC-SinkLoadOpt"}
!246 = !{!"KABPointerLoc", i1* null}
!247 = !{!"pushInfo", !248, !249, !250, !254, !255, !256, !257, !258, !259, !260, !261, !274, !275, !276, !277}
!248 = !{!"pushableAddresses"}
!249 = !{!"bindlessPushInfo"}
!250 = !{!"dynamicBufferInfo", !251, !252, !253}
!251 = !{!"firstIndex", i32 0}
!252 = !{!"numOffsets", i32 0}
!253 = !{!"forceDisabled", i1 false}
!254 = !{!"MaxNumberOfPushedBuffers", i32 0}
!255 = !{!"inlineConstantBufferSlot", i32 -1}
!256 = !{!"inlineConstantBufferOffset", i32 -1}
!257 = !{!"inlineConstantBufferGRFOffset", i32 -1}
!258 = !{!"constants"}
!259 = !{!"inputs"}
!260 = !{!"constantReg"}
!261 = !{!"simplePushInfoArr", !262, !271, !272, !273}
!262 = !{!"simplePushInfoArrVec[0]", !263, !264, !265, !266, !267, !268, !269, !270}
!263 = !{!"cbIdx", i32 0}
!264 = !{!"pushableAddressGrfOffset", i32 -1}
!265 = !{!"pushableOffsetGrfOffset", i32 -1}
!266 = !{!"offset", i32 0}
!267 = !{!"size", i32 0}
!268 = !{!"isStateless", i1 false}
!269 = !{!"isBindless", i1 false}
!270 = !{!"simplePushLoads"}
!271 = !{!"simplePushInfoArrVec[1]", !263, !264, !265, !266, !267, !268, !269, !270}
!272 = !{!"simplePushInfoArrVec[2]", !263, !264, !265, !266, !267, !268, !269, !270}
!273 = !{!"simplePushInfoArrVec[3]", !263, !264, !265, !266, !267, !268, !269, !270}
!274 = !{!"simplePushBufferUsed", i32 0}
!275 = !{!"pushAnalysisWIInfos"}
!276 = !{!"inlineRTGlobalPtrOffset", i32 0}
!277 = !{!"rtSyncSurfPtrOffset", i32 0}
!278 = !{!"pISAInfo", !279, !280}
!279 = !{!"shaderType", !"UNKNOWN"}
!280 = !{!"URBOutputLength", i32 0}
!281 = !{!"WaEnableICBPromotion", i1 false}
!282 = !{!"vsInfo", !283, !284, !285}
!283 = !{!"DrawIndirectBufferIndex", i32 -1}
!284 = !{!"vertexReordering", i32 -1}
!285 = !{!"MaxNumOfOutputs", i32 0}
!286 = !{!"hsInfo", !287, !288}
!287 = !{!"numPatchAttributesPatchBaseName", !""}
!288 = !{!"numVertexAttributesPatchBaseName", !""}
!289 = !{!"dsInfo", !285}
!290 = !{!"gsInfo", !285}
!291 = !{!"psInfo", !292, !293, !294, !295, !296, !297, !298, !299, !300, !301, !302, !303, !304, !305, !306, !307, !308, !309, !310, !311, !312, !313, !314, !315, !316, !317, !318, !319, !320, !321, !322, !323, !324, !325, !326}
!292 = !{!"BlendStateDisabledMask", i8 0}
!293 = !{!"SkipSrc0Alpha", i1 false}
!294 = !{!"DualSourceBlendingDisabled", i1 false}
!295 = !{!"ForceEnableSimd32", i1 false}
!296 = !{!"DisableSimd32WithDiscard", i1 false}
!297 = !{!"outputDepth", i1 false}
!298 = !{!"outputStencil", i1 false}
!299 = !{!"outputMask", i1 false}
!300 = !{!"blendToFillEnabled", i1 false}
!301 = !{!"forceEarlyZ", i1 false}
!302 = !{!"hasVersionedLoop", i1 false}
!303 = !{!"forceSingleSourceRTWAfterDualSourceRTW", i1 false}
!304 = !{!"requestCPSizeRelevant", i1 false}
!305 = !{!"requestCPSize", i1 false}
!306 = !{!"texelMaskFastClearMode", !"Disabled"}
!307 = !{!"NumSamples", i8 0}
!308 = !{!"blendOptimizationMode"}
!309 = !{!"colorOutputMask"}
!310 = !{!"ProvokingVertexModeNosIndex", i32 0}
!311 = !{!"ProvokingVertexModeNosPatch", !""}
!312 = !{!"ProvokingVertexModeLast", !"Negative"}
!313 = !{!"VertexAttributesBypass", i1 false}
!314 = !{!"LegacyBaryAssignmentDisableLinear", i1 false}
!315 = !{!"LegacyBaryAssignmentDisableLinearNoPerspective", i1 false}
!316 = !{!"LegacyBaryAssignmentDisableLinearCentroid", i1 false}
!317 = !{!"LegacyBaryAssignmentDisableLinearNoPerspectiveCentroid", i1 false}
!318 = !{!"LegacyBaryAssignmentDisableLinearSample", i1 false}
!319 = !{!"LegacyBaryAssignmentDisableLinearNoPerspectiveSample", i1 false}
!320 = !{!"MeshShaderWAPerPrimitiveUserDataEnable", !"Negative"}
!321 = !{!"meshShaderWAPerPrimitiveUserDataEnablePatchName", !""}
!322 = !{!"generatePatchesForRTWriteSends", i1 false}
!323 = !{!"forceVMask", i1 false}
!324 = !{!"WaDisableVRS", i1 false}
!325 = !{!"RelaxMemoryVisibilityFromPSOrdering", i1 false}
!326 = !{!"WaEnableVMaskUnderNonUnifromCF", i1 false}
!327 = !{!"csInfo", !328, !329, !330, !331, !332, !33, !34, !333, !334, !335, !336, !337, !338, !339, !340, !341, !342, !343, !344, !345, !66, !346, !347, !348, !349, !350, !351, !352}
!328 = !{!"maxWorkGroupSize", i32 0}
!329 = !{!"waveSize", i32 0}
!330 = !{!"ComputeShaderSecondCompile"}
!331 = !{!"forcedSIMDSize", i8 0}
!332 = !{!"forceTotalGRFNum", i32 0}
!333 = !{!"forceSpillCompression", i1 false}
!334 = !{!"allowLowerSimd", i1 false}
!335 = !{!"disableSimd32Slicing", i1 false}
!336 = !{!"disableSplitOnSpill", i1 false}
!337 = !{!"enableNewSpillCostFunction", i1 false}
!338 = !{!"forceVISAPreSched", i1 false}
!339 = !{!"forceUniformBuffer", i1 false}
!340 = !{!"forceUniformSurfaceSampler", i1 false}
!341 = !{!"disableLocalIdOrderOptimizations", i1 false}
!342 = !{!"disableDispatchAlongY", i1 false}
!343 = !{!"neededThreadIdLayout", i1* null}
!344 = !{!"forceTileYWalk", i1 false}
!345 = !{!"atomicBranch", i32 0}
!346 = !{!"disableEarlyOut", i1 false}
!347 = !{!"walkOrderEnabled", i1 false}
!348 = !{!"walkOrderOverride", i32 0}
!349 = !{!"ResForHfPacking"}
!350 = !{!"hasWaveMatrix", i1 false}
!351 = !{!"constantFoldSimdSize", i1 false}
!352 = !{!"isNodeShader", i1 false}
!353 = !{!"msInfo", !354, !355, !356, !357, !358, !359, !360, !361, !362, !363, !364, !312, !310, !365}
!354 = !{!"PrimitiveTopology", i32 3}
!355 = !{!"MaxNumOfPrimitives", i32 0}
!356 = !{!"MaxNumOfVertices", i32 0}
!357 = !{!"MaxNumOfPerPrimitiveOutputs", i32 0}
!358 = !{!"MaxNumOfPerVertexOutputs", i32 0}
!359 = !{!"WorkGroupSize", i32 0}
!360 = !{!"WorkGroupMemorySizeInBytes", i32 0}
!361 = !{!"IndexFormat", i32 6}
!362 = !{!"SubgroupSize", i32 0}
!363 = !{!"VPandRTAIndexAutostripEnable", i1 false}
!364 = !{!"MeshShaderWAPerPrimitiveUserDataEnable", i1 false}
!365 = !{!"numPrimitiveAttributesPatchBaseName", !""}
!366 = !{!"taskInfo", !285, !359, !360, !362}
!367 = !{!"NBarrierCnt", i32 0}
!368 = !{!"rtInfo", !369, !370, !371, !372, !373, !374, !375, !376, !377, !378, !379, !380, !381, !382, !383}
!369 = !{!"RayQueryAllocSizeInBytes", i32 0}
!370 = !{!"NumContinuations", i32 0}
!371 = !{!"RTAsyncStackAddrspace", i32 -1}
!372 = !{!"RTAsyncStackSurfaceStateOffset", i1* null}
!373 = !{!"SWHotZoneAddrspace", i32 -1}
!374 = !{!"SWHotZoneSurfaceStateOffset", i1* null}
!375 = !{!"SWStackAddrspace", i32 -1}
!376 = !{!"SWStackSurfaceStateOffset", i1* null}
!377 = !{!"RTSyncStackAddrspace", i32 -1}
!378 = !{!"RTSyncStackSurfaceStateOffset", i1* null}
!379 = !{!"doSyncDispatchRays", i1 false}
!380 = !{!"MemStyle", !"Xe"}
!381 = !{!"GlobalDataStyle", !"Xe"}
!382 = !{!"NeedsBTD", i1 true}
!383 = !{!"uberTileDimensions", i1* null}
!384 = !{!"EnableTextureIndirection", i1 false}
!385 = !{!"EnableSamplerIndirection", i1 false}
!386 = !{!"samplerStateStride", i32 0}
!387 = !{!"samplerStateOffset", i32 0}
!388 = !{!"textureStateStride", i32 0}
!389 = !{!"textureStateOffset", i32 0}
!390 = !{!"CurUniqueIndirectIdx", i32 0}
!391 = !{!"inlineDynTextures"}
!392 = !{!"inlineResInfoData"}
!393 = !{!"immConstant", !394, !395, !396}
!394 = !{!"data"}
!395 = !{!"sizes"}
!396 = !{!"zeroIdxs"}
!397 = !{!"stringConstants"}
!398 = !{!"inlineBuffers", !399, !403, !404}
!399 = !{!"inlineBuffersVec[0]", !400, !401, !402}
!400 = !{!"alignment", i32 0}
!401 = !{!"allocSize", i64 0}
!402 = !{!"Buffer"}
!403 = !{!"inlineBuffersVec[1]", !400, !401, !402}
!404 = !{!"inlineBuffersVec[2]", !400, !401, !402}
!405 = !{!"GlobalPointerProgramBinaryInfos"}
!406 = !{!"ConstantPointerProgramBinaryInfos"}
!407 = !{!"GlobalBufferAddressRelocInfo"}
!408 = !{!"ConstantBufferAddressRelocInfo"}
!409 = !{!"forceLscCacheList"}
!410 = !{!"SrvMap"}
!411 = !{!"RootConstantBufferOffsetInBytes"}
!412 = !{!"RasterizerOrderedByteAddressBuffer"}
!413 = !{!"RasterizerOrderedViews"}
!414 = !{!"MinNOSPushConstantSize", i32 0}
!415 = !{!"inlineProgramScopeOffsets"}
!416 = !{!"shaderData", !417}
!417 = !{!"numReplicas", i32 0}
!418 = !{!"URBInfo", !419, !420, !421}
!419 = !{!"has64BVertexHeaderInput", i1 false}
!420 = !{!"has64BVertexHeaderOutput", i1 false}
!421 = !{!"hasVertexHeader", i1 true}
!422 = !{!"m_ForcePullModel", i1 false}
!423 = !{!"UseBindlessImage", i1 false}
!424 = !{!"enableRangeReduce", i1 false}
!425 = !{!"disableNewTrigFuncRangeReduction", i1 false}
!426 = !{!"enableFRemToSRemOpt", i1 false}
!427 = !{!"enableSampleptrToLdmsptrSample0", i1 false}
!428 = !{!"enableSampleLptrToLdmsptrSample0", i1 false}
!429 = !{!"WaForceSIMD32MicropolyRasterize", i1 false}
!430 = !{!"allowMatchMadOptimizationforVS", i1 false}
!431 = !{!"disableMatchMadOptimizationForCS", i1 false}
!432 = !{!"disableMemOptforNegativeOffsetLoads", i1 false}
!433 = !{!"enableThreeWayLoadSpiltOpt", i1 false}
!434 = !{!"statefulResourcesNotAliased", i1 false}
!435 = !{!"disableMixMode", i1 false}
!436 = !{!"genericAccessesResolved", i1 false}
!437 = !{!"disableSeparateSpillPvtScratchSpace", i1 false}
!438 = !{!"enableSeparateSpillPvtScratchSpace", i1 false}
!439 = !{!"disableSeparateScratchWA", i1 false}
!440 = !{!"enableRemoveUnusedTGMFence", i1 false}
!441 = !{!"PrivateMemoryPerFG", !442, !443}
!442 = !{!"PrivateMemoryPerFGMap[0]", void (half addrspace(1)*, half addrspace(1)*, half addrspace(1)*, float, i8 addrspace(1)*, float addrspace(1)*, <8 x i32>, <8 x i32>, i8*, i32, i32, i32, i32, i32)* @_attn_fwd}
!443 = !{!"PrivateMemoryPerFGValue[0]", i32 0}
!444 = !{!"m_OptsToDisable"}
!445 = !{!"capabilities", !446}
!446 = !{!"globalVariableDecorationsINTEL", i1 false}
!447 = !{!"m_ShaderResourceViewMcsMask", !448, !449}
!448 = !{!"m_ShaderResourceViewMcsMaskVec[0]", i64 0}
!449 = !{!"m_ShaderResourceViewMcsMaskVec[1]", i64 0}
!450 = !{!"computedDepthMode", i32 0}
!451 = !{!"isHDCFastClearShader", i1 false}
!452 = !{!"argRegisterReservations", !453}
!453 = !{!"argRegisterReservationsVec[0]", i32 0}
!454 = !{!"SIMD16_SpillThreshold", i8 0}
!455 = !{!"SIMD32_SpillThreshold", i8 0}
!456 = !{!"m_CacheControlOption", !457, !458, !459, !460}
!457 = !{!"LscLoadCacheControlOverride", i8 0}
!458 = !{!"LscStoreCacheControlOverride", i8 0}
!459 = !{!"TgmLoadCacheControlOverride", i8 0}
!460 = !{!"TgmStoreCacheControlOverride", i8 0}
!461 = !{!"ModuleUsesBindless", i1 false}
!462 = !{!"predicationMap"}