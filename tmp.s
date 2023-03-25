; ModuleID = 'Context'
source_filename = "Context"

%SpriteBatch = type { ptr addrspace(5), ptr addrspace(5), ptr addrspace(5), i32, %Vec2 }
%Vec2 = type { float, float }
%Drawer = type { ptr addrspace(5), ptr addrspace(5), ptr addrspace(5), ptr addrspace(5) }
%GameState = type { [1 x %Drawer], %MultiSprite, [2 x ptr addrspace(5)], %Vec2, %BulletManager, %Stars }
%MultiSprite = type { %Vec2, %Vec2, %Vec2, %Vec2 }
%BulletManager = type { ptr addrspace(5), i32, ptr addrspace(5), ptr addrspace(5) }
%Stars = type { i32, [100 x %Star], %Drawer }
%Star = type { float, i1, %Vec2, %Color }
%Color = type { float, float, float, float }
%GFXContext = type { ptr addrspace(5), %Color, %IVec2 }
%IVec2 = type { i32, i32 }
%Input = type { %Vec2, i1 }
%ShaderFile = type { ptr addrspace(5), i32, i32 }
%Shader = type { i32 }
%Mat4 = type { [4 x [4 x float]] }
%SBQueue = type { ptr addrspace(5), i32 }
%Texture = type { i32, %IVec2 }
%Verts = type { ptr addrspace(5), i32 }
%Vert = type { float, float, float, float, float, float, float, float, float }
%Rect = type { float, float, float, float }
%Bullet = type { %Sprite, %Drawer, i1, %Vec2 }
%Sprite = type { %Vec2, %Vec2 }
%SBQueueEntry = type { i1, i64, ptr addrspace(5), ptr addrspace(5), ptr addrspace(5) }
%SBContext = type { ptr addrspace(5), ptr addrspace(5) }

@globalPtr = global ptr addrspace(5) null
@str = global [20 x i8] c"Could not init glfw\00"
@str.1 = global [11 x i8] c"CARpn Test\00"
@str.2 = global [325 x i8] c"#version 330 core\0Alayout (location = 0) in vec3 aVertex;\0Alayout (location = 1) in vec2 aTexCoords;\0Alayout (location = 2) in vec4 aColor;\0Auniform mat4 projection;\0Aout vec2 texCoords;\0Aout vec4 tintColor;\0Avoid main()\0A{\0A    gl_Position = projection * vec4(aVertex.xyz, 1.0);\0A    texCoords = aTexCoords;\0A    tintColor = aColor;\0A}\00"
@str.3 = global [150 x i8] c"#version 330 core\0A\0Ain vec2 texCoords;\0Ain vec4 tintColor;\0A\0Aout vec4 color;\0A\0Auniform sampler2D tex;\0A\0Avoid main() {\0A  color = texture(tex, texCoords);\0A}\00"
@str.4 = global [325 x i8] c"#version 330 core\0Alayout (location = 0) in vec3 aVertex;\0Alayout (location = 1) in vec2 aTexCoords;\0Alayout (location = 2) in vec4 aColor;\0Auniform mat4 projection;\0Aout vec2 texCoords;\0Aout vec4 tintColor;\0Avoid main()\0A{\0A    gl_Position = projection * vec4(aVertex.xyz, 1.0);\0A    texCoords = aTexCoords;\0A    tintColor = aColor;\0A}\00"
@str.5 = global [139 x i8] c"#version 330 core\0A\0Ain vec2 texCoords;\0Ain vec4 tintColor;\0A\0Aout vec4 color;\0A\0Auniform sampler2D tex;\0A\0Avoid main() {\0A     color = tintColor;\0A}\00"
@str.6 = global [11 x i8] c"projection\00"
@str.7 = global [9 x i8] c"ship.png\00"
@str.8 = global [12 x i8] c"bullets.png\00"

declare void @printf(ptr addrspace(5))

declare ptr addrspace(5) @malloc(i64)

declare ptr addrspace(5) @calloc(i64, i64)

declare ptr addrspace(5) @realloc(ptr addrspace(5), i64)

declare void @free(ptr addrspace(5))

declare void @exit(i32)

declare void @memcpy(ptr addrspace(5), ptr addrspace(5), i64)

declare float @sqrt(float)

declare void @printfloat(float)

declare i1 @glfwInit()

declare ptr addrspace(5) @glfwCreateWindow(i32, i32, ptr addrspace(5), ptr addrspace(5), ptr addrspace(5))

declare void @glfwTerminate()

declare void @glfwPollEvents()

declare void @glfwSwapBuffers(ptr addrspace(5))

declare void @glfwMakeContextCurrent(ptr addrspace(5))

declare i1 @glfwWindowShouldClose(ptr addrspace(5))

declare void @glfwGetFramebufferSize(ptr addrspace(5), ptr addrspace(5), ptr addrspace(5))

declare float @glfwGetTime()

declare void @glfwSwapInterval(i32)

declare void @glfwSetKeyCallback(ptr addrspace(5), ptr addrspace(5))

declare void @glClearColor(float, float, float, float)

declare void @glClear(i32)

declare void @glEnable(i32)

declare void @glBlendFunc(i32, i32)

declare void @glDeleteBuffers(i32, ptr addrspace(5))

declare void @glGenBuffers(i32, ptr addrspace(5))

declare void @glBindBuffer(i32, i32)

declare void @glBindTexture(i32, i32)

declare void @glBufferData(i32, i32, ptr addrspace(5), i32)

declare void @glVertexAttribPointer(i32, i32, i32, i32, i32, ptr addrspace(5))

declare void @glEnableVertexAttribArray(i32)

declare void @glDrawArrays(i32, i32, i32)

declare i32 @glCreateShader(i32)

declare i32 @glCreateProgram()

declare void @glShaderSource(i32, i32, ptr addrspace(5), ptr addrspace(5))

declare void @glCompileShader(i32)

declare void @glAttachShader(i32, i32)

declare void @glLinkProgram(i32)

declare void @glUseProgram(i32)

declare void @glGenTextures(i32, ptr addrspace(5))

declare void @glTexImage2D(i32, i32, i32, i32, i32, i32, i32, i32, ptr addrspace(5))

declare void @glGenerateMipmap(i32)

declare i32 @glGetUniformLocation(i32, ptr addrspace(5))

declare void @glUniformMatrix4fv(i32, i32, i32, ptr addrspace(5))

declare void @glTexParameteri(i32, i32, i32)

declare void @glScissor(i32, i32, i32, i32)

declare ptr addrspace(5) @stbi_load(ptr addrspace(5), ptr addrspace(5), ptr addrspace(5), ptr addrspace(5), i32)

declare void @stbi_image_free(ptr addrspace(5))

declare void @printint(i32)

declare void @setuprand()

declare float @randf()

declare float @getTimeFloat()

define i32 @main() {
entry:
  %sb = alloca %SpriteBatch, align 8
  %drawer = alloca %Drawer, align 8
  %ctx = alloca ptr addrspace(5), align 8
  %shd = alloca [2 x ptr addrspace(5)], align 8

dobody:                                           ; preds = %entry, %domerge
  %newTime = alloca float, align 4
  %frameTime = alloca float, align 4
  %calltmp = call float @getTimeFloat()
  store float %calltmp, ptr %newTime, align 4
  %readtmp = load float, ptr %newTime, align 4
  %readtmp1 = load float, ptr %currentTime, align 4
  %subtmp = fsub float %readtmp, %readtmp1
  store float %subtmp, ptr %frameTime, align 4
  %readtmp2 = load float, ptr %frameTime, align 4
  %gttmp = fcmp uge float %readtmp2, 2.500000e-01
  %ifcond = icmp ne i1 %gttmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

domerge:                                          ; preds = %entry

ifbody:                                           ; preds = %dobody
  store float 2.500000e-01, ptr %frameTime, align 4
  br label %ifmerge

ifmerge:                                          ; preds = %ifbody, %dobody
  %readtmp3 = load float, ptr %newTime, align 4
  store float %readtmp3, ptr %currentTime, align 4
  %readtmp4 = load float, ptr %accumulator, align 4
  %readtmp5 = load float, ptr %frameTime, align 4
  %addtmp = fadd float %readtmp4, %readtmp5
  store float %addtmp, ptr %accumulator, align 4
  %readtmp6 = load float, ptr %accumulator, align 4
  %readtmp7 = load float, ptr %dt, align 4
  %lttmp = fcmp ule float %readtmp6, %readtmp7
  %nottmp = xor i1 %lttmp, true
  %ifcond8 = icmp ne i1 %nottmp, false
  br i1 %ifcond8, label %ifbody9, label %ifmerge10

ifbody9:                                          ; preds = %ifmerge
  br label %dobody11

ifmerge10:                                        ; preds = %domerge12, %ifmerge
  %state = alloca %GameState, align 8
  %alpha = alloca float, align 4
  %readtmp14 = load float, ptr %accumulator, align 4
  %readtmp15 = load float, ptr %dt, align 4
  %divtmp = fdiv float %readtmp14, %readtmp15
  store float %divtmp, ptr %alpha, align 4
  %readtmp16 = load %GameState, ptr %prevState, align 8
  %readtmp17 = load %GameState, ptr %currState, align 8
  %readtmp18 = load float, ptr %alpha, align 4

dobody11:                                         ; preds = %domerge, %ifbody9
  %readtmp13 = load %GameState, ptr %prevState, align 8

domerge12:                                        ; preds = %domerge
  br label %ifmerge10
}

define ptr addrspace(5) @GFXContext.init_0() {
entry:
  %result = alloca ptr addrspace(5), align 8
  %calltmp = call ptr addrspace(5) @malloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %GFXContext], ptr addrspace(5) null, i32 1) to i32))
  store ptr addrspace(5) %calltmp, ptr %result, align 8
  %calltmp1 = call i1 @glfwInit()
  %nottmp = xor i1 %calltmp1, true
  %ifcond = icmp ne i1 %nottmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

ifbody:                                           ; preds = %entry
  %calltmp2 = call void @printf(ptr @str)
  %calltmp3 = call void @exit(i32 1)
  br label %ifmerge

ifmerge:                                          ; preds = %ifbody, %entry
  %readtmp = load ptr addrspace(5), ptr %result, align 8
  %0 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp, i32 0, i32 0
  %calltmp4 = call ptr addrspace(5) @glfwCreateWindow(i32 640, i32 480, ptr @str.1, i64 0, i64 0)
  store ptr addrspace(5) %calltmp4, ptr addrspace(5) %0, align 8
  %readtmp5 = load ptr addrspace(5), ptr %result, align 8
  %1 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp5, i32 0, i32 0
  %readtmp6 = load ptr addrspace(5), ptr addrspace(5) %1, align 8
  %calltmp7 = call void @glfwMakeContextCurrent(ptr addrspace(5) %readtmp6)
  %calltmp8 = call void @glfwSwapInterval(i32 1)
  %readtmp9 = load ptr addrspace(5), ptr %result, align 8
  %2 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp9, i32 0, i32 0
  %readtmp10 = load ptr addrspace(5), ptr addrspace(5) %2, align 8
  %readtmp11 = load ptr addrspace(5), ptr %result, align 8
  %3 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp11, i32 0, i32 2
  %4 = getelementptr inbounds %IVec2, ptr addrspace(5) %3, i32 0, i32 0
  %readtmp12 = load ptr addrspace(5), ptr %result, align 8
  %5 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp12, i32 0, i32 2
  %6 = getelementptr inbounds %IVec2, ptr addrspace(5) %5, i32 0, i32 1
  %calltmp13 = call void @glfwGetFramebufferSize(ptr addrspace(5) %readtmp10, ptr addrspace(5) %4, ptr addrspace(5) %6)
  %readtmp14 = load ptr addrspace(5), ptr %result, align 8
  %7 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp14, i32 0, i32 1
  %8 = getelementptr inbounds %Color, ptr addrspace(5) %7, i32 0, i32 0
  store float 0.000000e+00, ptr addrspace(5) %8, align 4
  %readtmp15 = load ptr addrspace(5), ptr %result, align 8
  %9 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp15, i32 0, i32 1
  %10 = getelementptr inbounds %Color, ptr addrspace(5) %9, i32 0, i32 1
  store float 0.000000e+00, ptr addrspace(5) %10, align 4
  %readtmp16 = load ptr addrspace(5), ptr %result, align 8
  %11 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp16, i32 0, i32 1
  %12 = getelementptr inbounds %Color, ptr addrspace(5) %11, i32 0, i32 2
  store float 0x3FA99999A0000000, ptr addrspace(5) %12, align 4
  %readtmp17 = load ptr addrspace(5), ptr %result, align 8
  %13 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp17, i32 0, i32 1
  %14 = getelementptr inbounds %Color, ptr addrspace(5) %13, i32 0, i32 3
  store float 1.000000e+00, ptr addrspace(5) %14, align 4
  %readtmp18 = load ptr addrspace(5), ptr %result, align 8
  ret ptr addrspace(5) %readtmp18
  %calltmp19 = call ptr addrspace(5) @GFXContext.init_0()
  store ptr addrspace(5) %calltmp19, ptr %ctx, align 8
  %readtmp20 = load ptr addrspace(5), ptr %ctx, align 8
}

define void @Input.init_0(ptr addrspace(5) %0) {
entry:
  %calltmp = call ptr addrspace(5) @malloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Input], ptr addrspace(5) null, i32 1) to i32))
  store ptr addrspace(5) %calltmp, ptr @globalPtr, align 8
}

define ptr addrspace(5) @Input.instance_0() {
entry:
  %readtmp = load ptr addrspace(5), ptr @globalPtr, align 8
  ret ptr addrspace(5) %readtmp
  %calltmp = call ptr addrspace(5) @Input.instance_0()
  %0 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp, i32 0, i32 0
  %1 = getelementptr inbounds %Vec2, ptr addrspace(5) %0, i32 0, i32 1
  store float 0.000000e+00, ptr addrspace(5) %1, align 4
  %calltmp1 = call ptr addrspace(5) @Input.instance_0()
  %2 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp1, i32 0, i32 0
  %3 = getelementptr inbounds %Vec2, ptr addrspace(5) %2, i32 0, i32 0
  store float 0.000000e+00, ptr addrspace(5) %3, align 4
  %4 = getelementptr inbounds %GFXContext, ptr addrspace(5) %0, i32 0, i32 0
  %readtmp2 = load ptr addrspace(5), ptr addrspace(5) %4, align 8
}

define void @Input.keyCallback_0(ptr addrspace(5) %0, i32 %1, i32 %2, i32 %3, i32 %4) {
entry:
  %action = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %3, ptr %action, align 4
  store i32 %1, ptr %key, align 4
  %adds = alloca %Vec2, align 8
  %5 = getelementptr inbounds %Vec2, ptr %adds, i32 0, i32 0
  store float 0.000000e+00, ptr %5, align 4
  %6 = getelementptr inbounds %Vec2, ptr %adds, i32 0, i32 1
  store float 0.000000e+00, ptr %6, align 4
  %readtmp = load i32, ptr %key, align 4
  %neqtmp = icmp eq i32 263, %readtmp
  %ifcond = icmp ne i1 %neqtmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

ifbody:                                           ; preds = %entry
  %7 = getelementptr inbounds %Vec2, ptr %adds, i32 0, i32 0
  store float -1.000000e+00, ptr %7, align 4
  br label %ifmerge

ifmerge:                                          ; preds = %ifbody, %entry
  %readtmp1 = load i32, ptr %key, align 4
  %neqtmp2 = icmp eq i32 262, %readtmp1
  %ifcond3 = icmp ne i1 %neqtmp2, false
  br i1 %ifcond3, label %ifbody4, label %ifmerge5

ifbody4:                                          ; preds = %ifmerge
  %8 = getelementptr inbounds %Vec2, ptr %adds, i32 0, i32 0
  store float 1.000000e+00, ptr %8, align 4
  br label %ifmerge5

ifmerge5:                                         ; preds = %ifbody4, %ifmerge
  %readtmp6 = load i32, ptr %key, align 4
  %neqtmp7 = icmp eq i32 265, %readtmp6
  %ifcond8 = icmp ne i1 %neqtmp7, false
  br i1 %ifcond8, label %ifbody9, label %ifmerge10

ifbody9:                                          ; preds = %ifmerge5
  %9 = getelementptr inbounds %Vec2, ptr %adds, i32 0, i32 1
  store float -1.000000e+00, ptr %9, align 4
  br label %ifmerge10

ifmerge10:                                        ; preds = %ifbody9, %ifmerge5
  %readtmp11 = load i32, ptr %key, align 4
  %neqtmp12 = icmp eq i32 264, %readtmp11
  %ifcond13 = icmp ne i1 %neqtmp12, false
  br i1 %ifcond13, label %ifbody14, label %ifmerge15

ifbody14:                                         ; preds = %ifmerge10
  %10 = getelementptr inbounds %Vec2, ptr %adds, i32 0, i32 1
  store float 1.000000e+00, ptr %10, align 4
  br label %ifmerge15

ifmerge15:                                        ; preds = %ifbody14, %ifmerge10
  %readtmp16 = load i32, ptr %key, align 4
  %neqtmp17 = icmp eq i32 65, %readtmp16
  %ifcond18 = icmp ne i1 %neqtmp17, false
  br i1 %ifcond18, label %ifbody19, label %ifmerge20

ifbody19:                                         ; preds = %ifmerge15
  %11 = getelementptr inbounds %Vec2, ptr %adds, i32 0, i32 0
  store float -1.000000e+00, ptr %11, align 4
  br label %ifmerge20

ifmerge20:                                        ; preds = %ifbody19, %ifmerge15
  %readtmp21 = load i32, ptr %key, align 4
  %neqtmp22 = icmp eq i32 68, %readtmp21
  %ifcond23 = icmp ne i1 %neqtmp22, false
  br i1 %ifcond23, label %ifbody24, label %ifmerge25

ifbody24:                                         ; preds = %ifmerge20
  %12 = getelementptr inbounds %Vec2, ptr %adds, i32 0, i32 0
  store float 1.000000e+00, ptr %12, align 4
  br label %ifmerge25

ifmerge25:                                        ; preds = %ifbody24, %ifmerge20
  %readtmp26 = load i32, ptr %key, align 4
  %neqtmp27 = icmp eq i32 87, %readtmp26
  %ifcond28 = icmp ne i1 %neqtmp27, false
  br i1 %ifcond28, label %ifbody29, label %ifmerge30

ifbody29:                                         ; preds = %ifmerge25
  %13 = getelementptr inbounds %Vec2, ptr %adds, i32 0, i32 1
  store float -1.000000e+00, ptr %13, align 4
  br label %ifmerge30

ifmerge30:                                        ; preds = %ifbody29, %ifmerge25
  %readtmp31 = load i32, ptr %key, align 4
  %neqtmp32 = icmp eq i32 83, %readtmp31
  %ifcond33 = icmp ne i1 %neqtmp32, false
  br i1 %ifcond33, label %ifbody34, label %ifmerge35

ifbody34:                                         ; preds = %ifmerge30
  %14 = getelementptr inbounds %Vec2, ptr %adds, i32 0, i32 1
  store float 1.000000e+00, ptr %14, align 4
  br label %ifmerge35

ifmerge35:                                        ; preds = %ifbody34, %ifmerge30
  %readtmp36 = load i32, ptr %action, align 4
  %neqtmp37 = icmp eq i32 0, %readtmp36
  %ifcond38 = icmp ne i1 %neqtmp37, false
  br i1 %ifcond38, label %ifbody39, label %ifmerge40

ifbody39:                                         ; preds = %ifmerge35
  %calltmp = call ptr addrspace(5) @Input.instance_0()
  %15 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp, i32 0, i32 0
  %calltmp41 = call ptr addrspace(5) @Input.instance_0()
  %16 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp41, i32 0, i32 0
  %readtmp42 = load %Vec2, ptr addrspace(5) %16, align 4
  %readtmp43 = load %Vec2, ptr %adds, align 4

ifmerge40:                                        ; preds = %ifmerge45, %ifmerge35
  %readtmp47 = load i32, ptr %action, align 4
  %neqtmp48 = icmp eq i32 1, %readtmp47
  %ifcond49 = icmp ne i1 %neqtmp48, false
  br i1 %ifcond49, label %ifbody50, label %ifmerge51

ifbody44:                                         ; preds = %entry
  %calltmp46 = call ptr addrspace(5) @Input.instance_0()
  %17 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp46, i32 0, i32 1
  store i1 false, ptr addrspace(5) %17, align 1
  br label %ifmerge45

ifmerge45:                                        ; preds = %ifbody44, %entry
  br label %ifmerge40

ifbody50:                                         ; preds = %ifmerge40
  %calltmp52 = call ptr addrspace(5) @Input.instance_0()
  %18 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp52, i32 0, i32 0
  %calltmp53 = call ptr addrspace(5) @Input.instance_0()
  %19 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp53, i32 0, i32 0
  %readtmp54 = load %Vec2, ptr addrspace(5) %19, align 4
  %readtmp55 = load %Vec2, ptr %adds, align 4
  %calltmp56 = call %Vec2 @Vec2.add_0(%Vec2 %readtmp54, %Vec2 %readtmp55)
  store %Vec2 %calltmp56, ptr addrspace(5) %18, align 4
  %readtmp57 = load i32, ptr %key, align 4
  %neqtmp58 = icmp eq i32 32, %readtmp57
  %ifcond59 = icmp ne i1 %neqtmp58, false
  br i1 %ifcond59, label %ifbody60, label %ifmerge61

ifmerge51:                                        ; preds = %ifmerge61, %ifmerge40
  ret void
  %calltmp63 = call void @glfwSetKeyCallback(ptr addrspace(5) %readtmp2, ptr @Input.keyCallback_0)
  ret void
  %calltmp64 = call void @Input.init_0(ptr addrspace(5) %readtmp20)
  %elemtemp = getelementptr inbounds [2 x ptr addrspace(5)], ptr %shd, i32 0, i32 0

ifbody60:                                         ; preds = %ifbody50
  %calltmp62 = call ptr addrspace(5) @Input.instance_0()
  %20 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp62, i32 0, i32 1
  store i1 true, ptr addrspace(5) %20, align 1
  br label %ifmerge61

ifmerge61:                                        ; preds = %ifbody60, %ifbody50
  br label %ifmerge51
}

define %Vec2 @Vec2.mul_0(%Vec2 %0, float %1) {
entry:
  %result = alloca %Vec2, align 8
  %extracted = extractvalue %Vec2 %0, 0
  %multmp = fmul float %extracted, %1
  %2 = getelementptr inbounds %Vec2, ptr %result, i32 0, i32 0
  store float %multmp, ptr %2, align 4
  %extracted1 = extractvalue %Vec2 %0, 1
  %multmp2 = fmul float %extracted1, %1
  %3 = getelementptr inbounds %Vec2, ptr %result, i32 0, i32 1
  store float %multmp2, ptr %3, align 4
  %readtmp = load %Vec2, ptr %result, align 4
  ret %Vec2 %readtmp
  %calltmp = call %Vec2 @Vec2.mul_0(%Vec2 %readtmp43, float -1.000000e+00)
}

define %Vec2 @Vec2.add_0(%Vec2 %0, %Vec2 %1) {
entry:
  %result = alloca %Vec2, align 8
  %extracted = extractvalue %Vec2 %0, 0
  %extracted1 = extractvalue %Vec2 %1, 0
  %addtmp = fadd float %extracted, %extracted1
  %2 = getelementptr inbounds %Vec2, ptr %result, i32 0, i32 0
  store float %addtmp, ptr %2, align 4
  %extracted2 = extractvalue %Vec2 %0, 1
  %extracted3 = extractvalue %Vec2 %1, 1
  %addtmp4 = fadd float %extracted2, %extracted3
  %3 = getelementptr inbounds %Vec2, ptr %result, i32 0, i32 1
  store float %addtmp4, ptr %3, align 4
  %readtmp = load %Vec2, ptr %result, align 4
  ret %Vec2 %readtmp
  %calltmp = call %Vec2 @Vec2.add_0(%Vec2 %readtmp42, %Vec2 %calltmp)
  store %Vec2 %calltmp, ptr addrspace(5) %15, align 4
  %readtmp5 = load i32, ptr %key, align 4
  %neqtmp = icmp eq i32 32, %readtmp5
  %ifcond = icmp ne i1 %neqtmp, false
  br i1 %ifcond, label %ifbody44, label %ifmerge45
}

define ptr addrspace(5) @getTexShaders_0() {
entry:
  %result = alloca ptr addrspace(5), align 8
  %calltmp = call ptr addrspace(5) @calloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %ShaderFile], ptr addrspace(5) null, i32 1) to i32), i64 2)
  store ptr addrspace(5) %calltmp, ptr %result, align 8
  %readtmp = load ptr addrspace(5), ptr %result, align 8
  %elemtemp = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp, i32 0, i32 0
  %0 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp, i32 0, i32 0
  %calltmp1 = call ptr addrspace(5) @calloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x ptr addrspace(5)], ptr addrspace(5) null, i32 1) to i32), i64 1)
  store ptr addrspace(5) %calltmp1, ptr addrspace(5) %0, align 8
  %readtmp2 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp3 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp2, i32 0, i32 0
  %1 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp3, i32 0, i32 2
  store i32 35633, ptr addrspace(5) %1, align 4
  %readtmp4 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp5 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp4, i32 0, i32 0
  %2 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp5, i32 0, i32 1
  store i32 1, ptr addrspace(5) %2, align 4
  %readtmp6 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp7 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp6, i32 0, i32 0
  %3 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp7, i32 0, i32 0
  %readtmp8 = load ptr addrspace(5), ptr addrspace(5) %3, align 8
  store ptr @str.2, ptr addrspace(5) %readtmp8, align 8
  %readtmp9 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp10 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp9, i32 0, i32 1
  %4 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp10, i32 0, i32 0
  %calltmp11 = call ptr addrspace(5) @calloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x ptr addrspace(5)], ptr addrspace(5) null, i32 1) to i32), i64 1)
  store ptr addrspace(5) %calltmp11, ptr addrspace(5) %4, align 8
  %readtmp12 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp13 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp12, i32 0, i32 1
  %5 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp13, i32 0, i32 2
  store i32 35632, ptr addrspace(5) %5, align 4
  %readtmp14 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp15 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp14, i32 0, i32 1
  %6 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp15, i32 0, i32 1
  store i32 1, ptr addrspace(5) %6, align 4
  %readtmp16 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp17 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp16, i32 0, i32 1
  %7 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp17, i32 0, i32 0
  %readtmp18 = load ptr addrspace(5), ptr addrspace(5) %7, align 8
  store ptr @str.3, ptr addrspace(5) %readtmp18, align 8
  %readtmp19 = load ptr addrspace(5), ptr %result, align 8
  ret ptr addrspace(5) %readtmp19
  %calltmp20 = call ptr addrspace(5) @getTexShaders_0()
}

define ptr addrspace(5) @Shader.new_0(ptr addrspace(5) %0, i32 %1) {
entry:
  %result = alloca ptr addrspace(5), align 8
  %files = alloca ptr addrspace(5), align 8
  %count = alloca i32, align 4
  store i32 %1, ptr %count, align 4
  store ptr addrspace(5) %0, ptr %files, align 8
  %calltmp = call ptr addrspace(5) @malloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Shader], ptr addrspace(5) null, i32 1) to i32))
  store ptr addrspace(5) %calltmp, ptr %result, align 8
  %readtmp = load ptr addrspace(5), ptr %result, align 8
  %2 = getelementptr inbounds %Shader, ptr addrspace(5) %readtmp, i32 0, i32 0
  %calltmp1 = call i32 @glCreateProgram()
  store i32 %calltmp1, ptr addrspace(5) %2, align 4
  %readtmp2 = load i32, ptr %count, align 4
  %neqtmp = icmp eq i32 0, %readtmp2
  %ifcond = icmp ne i1 %neqtmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

ifbody:                                           ; preds = %entry
  ret i64 0
  br label %ifmerge

ifmerge:                                          ; preds = %ifbody, %entry
  br label %dobody

dobody:                                           ; preds = %dobody, %ifmerge
  %readtmp3 = load i32, ptr %count, align 4
  %subtmp = sub i32 %readtmp3, 1
  store i32 %subtmp, ptr %count, align 4
  %shader = alloca i32, align 4
  %readtmp4 = load ptr addrspace(5), ptr %files, align 8
  %readtmp5 = load i32, ptr %count, align 4
  %idxtmp = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp4, i32 %readtmp5
  %3 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %idxtmp, i32 0, i32 2
  %readtmp6 = load i32, ptr addrspace(5) %3, align 4
  %calltmp7 = call i32 @glCreateShader(i32 %readtmp6)
  store i32 %calltmp7, ptr %shader, align 4
  %readtmp8 = load i32, ptr %shader, align 4
  %readtmp9 = load ptr addrspace(5), ptr %files, align 8
  %readtmp10 = load i32, ptr %count, align 4
  %idxtmp11 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp9, i32 %readtmp10
  %4 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %idxtmp11, i32 0, i32 1
  %readtmp12 = load i32, ptr addrspace(5) %4, align 4
  %readtmp13 = load ptr addrspace(5), ptr %files, align 8
  %readtmp14 = load i32, ptr %count, align 4
  %idxtmp15 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp13, i32 %readtmp14
  %5 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %idxtmp15, i32 0, i32 0
  %readtmp16 = load ptr addrspace(5), ptr addrspace(5) %5, align 8
  %calltmp17 = call void @glShaderSource(i32 %readtmp8, i32 %readtmp12, ptr addrspace(5) %readtmp16, i64 0)
  %readtmp18 = load i32, ptr %shader, align 4
  %calltmp19 = call void @glCompileShader(i32 %readtmp18)
  %readtmp20 = load ptr addrspace(5), ptr %result, align 8
  %6 = getelementptr inbounds %Shader, ptr addrspace(5) %readtmp20, i32 0, i32 0
  %readtmp21 = load i32, ptr addrspace(5) %6, align 4
  %readtmp22 = load i32, ptr %shader, align 4
  %calltmp23 = call void @glAttachShader(i32 %readtmp21, i32 %readtmp22)
  %readtmp24 = load i32, ptr %count, align 4
  %gttmp = icmp ugt i32 %readtmp24, 0
  %docond = icmp ne i1 %gttmp, false
  br i1 %docond, label %dobody, label %domerge

domerge:                                          ; preds = %dobody
  %readtmp25 = load ptr addrspace(5), ptr %result, align 8
  %7 = getelementptr inbounds %Shader, ptr addrspace(5) %readtmp25, i32 0, i32 0
  %readtmp26 = load i32, ptr addrspace(5) %7, align 4
  %calltmp27 = call void @glLinkProgram(i32 %readtmp26)
  %readtmp28 = load ptr addrspace(5), ptr %result, align 8
  ret ptr addrspace(5) %readtmp28
  %calltmp29 = call ptr addrspace(5) @Shader.new_0(ptr addrspace(5) %calltmp20, i32 2)
  store ptr addrspace(5) %calltmp29, ptr %elemtemp, align 8
  %elemtemp = getelementptr inbounds [2 x ptr addrspace(5)], ptr %shd, i32 0, i32 1
}

define ptr addrspace(5) @getPixShaders_0() {
entry:
  %result = alloca ptr addrspace(5), align 8
  %calltmp = call ptr addrspace(5) @calloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %ShaderFile], ptr addrspace(5) null, i32 1) to i32), i64 2)
  store ptr addrspace(5) %calltmp, ptr %result, align 8
  %readtmp = load ptr addrspace(5), ptr %result, align 8
  %elemtemp = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp, i32 0, i32 0
  %0 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp, i32 0, i32 0
  %calltmp1 = call ptr addrspace(5) @calloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x ptr addrspace(5)], ptr addrspace(5) null, i32 1) to i32), i64 1)
  store ptr addrspace(5) %calltmp1, ptr addrspace(5) %0, align 8
  %readtmp2 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp3 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp2, i32 0, i32 0
  %1 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp3, i32 0, i32 2
  store i32 35633, ptr addrspace(5) %1, align 4
  %readtmp4 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp5 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp4, i32 0, i32 0
  %2 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp5, i32 0, i32 1
  store i32 1, ptr addrspace(5) %2, align 4
  %readtmp6 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp7 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp6, i32 0, i32 0
  %3 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp7, i32 0, i32 0
  %readtmp8 = load ptr addrspace(5), ptr addrspace(5) %3, align 8
  store ptr @str.4, ptr addrspace(5) %readtmp8, align 8
  %readtmp9 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp10 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp9, i32 0, i32 1
  %4 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp10, i32 0, i32 0
  %calltmp11 = call ptr addrspace(5) @calloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x ptr addrspace(5)], ptr addrspace(5) null, i32 1) to i32), i64 1)
  store ptr addrspace(5) %calltmp11, ptr addrspace(5) %4, align 8
  %readtmp12 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp13 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp12, i32 0, i32 1
  %5 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp13, i32 0, i32 2
  store i32 35632, ptr addrspace(5) %5, align 4
  %readtmp14 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp15 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp14, i32 0, i32 1
  %6 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp15, i32 0, i32 1
  store i32 1, ptr addrspace(5) %6, align 4
  %readtmp16 = load ptr addrspace(5), ptr %result, align 8
  %elemtemp17 = getelementptr inbounds [1 x %ShaderFile], ptr addrspace(5) %readtmp16, i32 0, i32 1
  %7 = getelementptr inbounds %ShaderFile, ptr addrspace(5) %elemtemp17, i32 0, i32 0
  %readtmp18 = load ptr addrspace(5), ptr addrspace(5) %7, align 8
  store ptr @str.5, ptr addrspace(5) %readtmp18, align 8
  %readtmp19 = load ptr addrspace(5), ptr %result, align 8
  ret ptr addrspace(5) %readtmp19
  %calltmp20 = call ptr addrspace(5) @getPixShaders_0()
  %calltmp21 = call ptr addrspace(5) @Shader.new_0(ptr addrspace(5) %calltmp20, i32 2)
  store ptr addrspace(5) %calltmp21, ptr %elemtemp, align 8
  %elemtemp22 = getelementptr inbounds [2 x ptr addrspace(5)], ptr %shd, i32 0, i32 0
  %readtmp23 = load ptr addrspace(5), ptr %elemtemp22, align 8
}

define %Vec2 @Vec2.new_0(float %0, float %1) {
entry:
  %result = alloca %Vec2, align 8
  %2 = getelementptr inbounds %Vec2, ptr %result, i32 0, i32 1
  store float %1, ptr %2, align 4
  %3 = getelementptr inbounds %Vec2, ptr %result, i32 0, i32 0
  store float %0, ptr %3, align 4
  %readtmp = load %Vec2, ptr %result, align 4
  ret %Vec2 %readtmp
  %calltmp = call %Vec2 @Vec2.new_0(float 6.400000e+02, float 4.800000e+02)
}

define void @Shader.setSize_0(ptr addrspace(5) %0, %Vec2 %1) {
entry:
  %proj = alloca %Mat4, align 8
  %size = alloca %Vec2, align 8
  %shd = alloca ptr addrspace(5), align 8
  store %Vec2 %1, ptr %size, align 4
  store ptr addrspace(5) %0, ptr %shd, align 8
  %readtmp = load %Vec2, ptr %size, align 4
  %extracted = extractvalue %Vec2 %readtmp, 0
  %readtmp1 = load %Vec2, ptr %size, align 4
  %extracted2 = extractvalue %Vec2 %readtmp1, 1
}

define %Mat4 @Mat4.ortho_0(float %0, float %1, float %2, float %3, float %4, float %5) {
entry:
  %result = alloca %Mat4, align 8
  %f = alloca float, align 4
  store float %5, ptr %f, align 4
  %n = alloca float, align 4
  store float %4, ptr %n, align 4
  %t = alloca float, align 4
  store float %3, ptr %t, align 4
  %b = alloca float, align 4
  store float %2, ptr %b, align 4
  %r = alloca float, align 4
  store float %1, ptr %r, align 4
  %l = alloca float, align 4
  store float %0, ptr %l, align 4
  %6 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp = getelementptr inbounds [4 x [4 x float]], ptr %6, i32 0, i32 0
  %elemtemp1 = getelementptr inbounds [4 x float], ptr %elemtemp, i32 0, i32 0
  %readtmp = load float, ptr %r, align 4
  %readtmp2 = load float, ptr %l, align 4
  %subtmp = fsub float %readtmp, %readtmp2
  %divtmp = fdiv float 2.000000e+00, %subtmp
  store float %divtmp, ptr %elemtemp1, align 4
  %7 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp3 = getelementptr inbounds [4 x [4 x float]], ptr %7, i32 0, i32 0
  %elemtemp4 = getelementptr inbounds [4 x float], ptr %elemtemp3, i32 0, i32 1
  store float 0.000000e+00, ptr %elemtemp4, align 4
  %8 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp5 = getelementptr inbounds [4 x [4 x float]], ptr %8, i32 0, i32 0
  %elemtemp6 = getelementptr inbounds [4 x float], ptr %elemtemp5, i32 0, i32 2
  store float 0.000000e+00, ptr %elemtemp6, align 4
  %9 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp7 = getelementptr inbounds [4 x [4 x float]], ptr %9, i32 0, i32 0
  %elemtemp8 = getelementptr inbounds [4 x float], ptr %elemtemp7, i32 0, i32 3
  store float 0.000000e+00, ptr %elemtemp8, align 4
  %10 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp9 = getelementptr inbounds [4 x [4 x float]], ptr %10, i32 0, i32 1
  %elemtemp10 = getelementptr inbounds [4 x float], ptr %elemtemp9, i32 0, i32 0
  store float 0.000000e+00, ptr %elemtemp10, align 4
  %11 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp11 = getelementptr inbounds [4 x [4 x float]], ptr %11, i32 0, i32 1
  %elemtemp12 = getelementptr inbounds [4 x float], ptr %elemtemp11, i32 0, i32 1
  %readtmp13 = load float, ptr %t, align 4
  %readtmp14 = load float, ptr %b, align 4
  %subtmp15 = fsub float %readtmp13, %readtmp14
  %divtmp16 = fdiv float 2.000000e+00, %subtmp15
  store float %divtmp16, ptr %elemtemp12, align 4
  %12 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp17 = getelementptr inbounds [4 x [4 x float]], ptr %12, i32 0, i32 1
  %elemtemp18 = getelementptr inbounds [4 x float], ptr %elemtemp17, i32 0, i32 2
  store float 0.000000e+00, ptr %elemtemp18, align 4
  %13 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp19 = getelementptr inbounds [4 x [4 x float]], ptr %13, i32 0, i32 1
  %elemtemp20 = getelementptr inbounds [4 x float], ptr %elemtemp19, i32 0, i32 3
  store float 0.000000e+00, ptr %elemtemp20, align 4
  %14 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp21 = getelementptr inbounds [4 x [4 x float]], ptr %14, i32 0, i32 2
  %elemtemp22 = getelementptr inbounds [4 x float], ptr %elemtemp21, i32 0, i32 0
  store float 0.000000e+00, ptr %elemtemp22, align 4
  %15 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp23 = getelementptr inbounds [4 x [4 x float]], ptr %15, i32 0, i32 2
  %elemtemp24 = getelementptr inbounds [4 x float], ptr %elemtemp23, i32 0, i32 1
  store float 0.000000e+00, ptr %elemtemp24, align 4
  %16 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp25 = getelementptr inbounds [4 x [4 x float]], ptr %16, i32 0, i32 2
  %elemtemp26 = getelementptr inbounds [4 x float], ptr %elemtemp25, i32 0, i32 2
  %readtmp27 = load float, ptr %f, align 4
  %readtmp28 = load float, ptr %n, align 4
  %subtmp29 = fsub float %readtmp27, %readtmp28
  %divtmp30 = fdiv float -2.000000e+00, %subtmp29
  store float %divtmp30, ptr %elemtemp26, align 4
  %17 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp31 = getelementptr inbounds [4 x [4 x float]], ptr %17, i32 0, i32 2
  %elemtemp32 = getelementptr inbounds [4 x float], ptr %elemtemp31, i32 0, i32 3
  store float 0.000000e+00, ptr %elemtemp32, align 4
  %18 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp33 = getelementptr inbounds [4 x [4 x float]], ptr %18, i32 0, i32 3
  %elemtemp34 = getelementptr inbounds [4 x float], ptr %elemtemp33, i32 0, i32 0
  %readtmp35 = load float, ptr %r, align 4
  %readtmp36 = load float, ptr %l, align 4
  %addtmp = fadd float %readtmp35, %readtmp36
  %multmp = fmul float %addtmp, -1.000000e+00
  %readtmp37 = load float, ptr %r, align 4
  %readtmp38 = load float, ptr %l, align 4
  %subtmp39 = fsub float %readtmp37, %readtmp38
  %divtmp40 = fdiv float %multmp, %subtmp39
  store float %divtmp40, ptr %elemtemp34, align 4
  %19 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp41 = getelementptr inbounds [4 x [4 x float]], ptr %19, i32 0, i32 3
  %elemtemp42 = getelementptr inbounds [4 x float], ptr %elemtemp41, i32 0, i32 1
  %readtmp43 = load float, ptr %t, align 4
  %readtmp44 = load float, ptr %b, align 4
  %addtmp45 = fadd float %readtmp43, %readtmp44
  %multmp46 = fmul float %addtmp45, -1.000000e+00
  %readtmp47 = load float, ptr %t, align 4
  %readtmp48 = load float, ptr %b, align 4
  %subtmp49 = fsub float %readtmp47, %readtmp48
  %divtmp50 = fdiv float %multmp46, %subtmp49
  store float %divtmp50, ptr %elemtemp42, align 4
  %20 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp51 = getelementptr inbounds [4 x [4 x float]], ptr %20, i32 0, i32 3
  %elemtemp52 = getelementptr inbounds [4 x float], ptr %elemtemp51, i32 0, i32 2
  %readtmp53 = load float, ptr %f, align 4
  %readtmp54 = load float, ptr %n, align 4
  %addtmp55 = fadd float %readtmp53, %readtmp54
  %multmp56 = fmul float %addtmp55, -1.000000e+00
  %readtmp57 = load float, ptr %f, align 4
  %readtmp58 = load float, ptr %n, align 4
  %subtmp59 = fsub float %readtmp57, %readtmp58
  %divtmp60 = fdiv float %multmp56, %subtmp59
  store float %divtmp60, ptr %elemtemp52, align 4
  %21 = getelementptr inbounds %Mat4, ptr %result, i32 0, i32 0
  %elemtemp61 = getelementptr inbounds [4 x [4 x float]], ptr %21, i32 0, i32 3
  %elemtemp62 = getelementptr inbounds [4 x float], ptr %elemtemp61, i32 0, i32 3
  store float 1.000000e+00, ptr %elemtemp62, align 4
  %readtmp63 = load %Mat4, ptr %result, align 4
  ret %Mat4 %readtmp63
  %calltmp = call %Mat4 @Mat4.ortho_0(float 0.000000e+00, float %extracted, float %extracted2, float 0.000000e+00, float 1.000000e+02, float -1.000000e+00)
  store %Mat4 %calltmp, ptr %proj, align 4
  %readtmp64 = load ptr addrspace(5), ptr %shd, align 8
  %22 = getelementptr inbounds %Shader, ptr addrspace(5) %readtmp64, i32 0, i32 0
  %readtmp65 = load i32, ptr addrspace(5) %22, align 4
  %calltmp66 = call void @glUseProgram(i32 %readtmp65)
  %readtmp67 = load ptr addrspace(5), ptr %shd, align 8
  %23 = getelementptr inbounds %Shader, ptr addrspace(5) %readtmp67, i32 0, i32 0
  %readtmp68 = load i32, ptr addrspace(5) %23, align 4
  %calltmp69 = call i32 @glGetUniformLocation(i32 %readtmp68, ptr @str.6)
  %24 = getelementptr inbounds %Mat4, ptr %proj, i32 0, i32 0
  %calltmp70 = call void @glUniformMatrix4fv(i32 %calltmp69, i32 1, i32 0, ptr %24)
  ret void
  %calltmp71 = call void @Shader.setSize_0(ptr addrspace(5) %readtmp23, %Vec2 %calltmp)
  %elemtemp72 = getelementptr inbounds [2 x ptr addrspace(5)], ptr %shd, i32 0, i32 1
  %readtmp73 = load ptr addrspace(5), ptr %elemtemp72, align 8
  %calltmp74 = call %Vec2 @Vec2.new_0(float 6.400000e+02, float 4.800000e+02)
  %calltmp75 = call void @Shader.setSize_0(ptr addrspace(5) %readtmp73, %Vec2 %calltmp74)
}

define void @SpriteBatch.init_0(ptr addrspace(5) %0) {
entry:
  %sb = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %sb, align 8
  %readtmp = load ptr addrspace(5), ptr %sb, align 8
  %1 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp, i32 0, i32 3
  store i32 0, ptr addrspace(5) %1, align 4
  %readtmp1 = load ptr addrspace(5), ptr %sb, align 8
  %2 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp1, i32 0, i32 2
  %calltmp = call ptr addrspace(5) @malloc(i64 0)
  store ptr addrspace(5) %calltmp, ptr addrspace(5) %2, align 8
  %readtmp2 = load ptr addrspace(5), ptr %sb, align 8
  %3 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp2, i32 0, i32 1
  %calltmp3 = call ptr addrspace(5) @malloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %SBQueue], ptr addrspace(5) null, i32 1) to i32))
  store ptr addrspace(5) %calltmp3, ptr addrspace(5) %3, align 8
  %readtmp4 = load ptr addrspace(5), ptr %sb, align 8
  %4 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp4, i32 0, i32 0
  %calltmp5 = call ptr addrspace(5) @malloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %SBQueue], ptr addrspace(5) null, i32 1) to i32))
  store ptr addrspace(5) %calltmp5, ptr addrspace(5) %4, align 8
  %readtmp6 = load ptr addrspace(5), ptr %sb, align 8
  %5 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp6, i32 0, i32 1
  %readtmp7 = load ptr addrspace(5), ptr addrspace(5) %5, align 8
  %6 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp7, i32 0, i32 1
  store i32 0, ptr addrspace(5) %6, align 4
  %readtmp8 = load ptr addrspace(5), ptr %sb, align 8
  %7 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp8, i32 0, i32 0
  %readtmp9 = load ptr addrspace(5), ptr addrspace(5) %7, align 8
  %8 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp9, i32 0, i32 1
  store i32 0, ptr addrspace(5) %8, align 4
  %readtmp10 = load ptr addrspace(5), ptr %sb, align 8
  %9 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp10, i32 0, i32 1
  %readtmp11 = load ptr addrspace(5), ptr addrspace(5) %9, align 8
  %10 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp11, i32 0, i32 0
  %calltmp12 = call ptr addrspace(5) @malloc(i64 10)
  store ptr addrspace(5) %calltmp12, ptr addrspace(5) %10, align 8
  %readtmp13 = load ptr addrspace(5), ptr %sb, align 8
  %11 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp13, i32 0, i32 0
  %readtmp14 = load ptr addrspace(5), ptr addrspace(5) %11, align 8
  %12 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp14, i32 0, i32 0
  %calltmp15 = call ptr addrspace(5) @malloc(i64 10)
  store ptr addrspace(5) %calltmp15, ptr addrspace(5) %12, align 8
  ret void
  %calltmp16 = call void @SpriteBatch.init_0(ptr %sb)
  %t = alloca float, align 4
  %dt = alloca float, align 4
  %currentTime = alloca float, align 4
  %accumulator = alloca float, align 4
  store float 0.000000e+00, ptr %t, align 4
  store float 0x3FA47AE140000000, ptr %dt, align 4
  %calltmp17 = call float @getTimeFloat()
  store float %calltmp17, ptr %currentTime, align 4
  store float 0.000000e+00, ptr %accumulator, align 4
  %currState = alloca %GameState, align 8
  %prevState = alloca %GameState, align 8
  %readtmp18 = load [2 x ptr addrspace(5)], ptr %shd, align 8
}

define %GameState @GameState.init_0([2 x ptr addrspace(5)] %0) {
entry:
  %result = alloca %GameState, align 8
  %shd = alloca [2 x ptr addrspace(5)], align 8
  store [2 x ptr addrspace(5)] %0, ptr %shd, align 8
  %1 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 2
  %elemtemp = getelementptr inbounds [2 x ptr addrspace(5)], ptr %1, i32 0, i32 0
}

define ptr addrspace(5) @Texture.new_0(ptr addrspace(5) %0) {
entry:
  %file = alloca ptr addrspace(5), align 8
  %result = alloca ptr addrspace(5), align 8
  %data = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %file, align 8
  %calltmp = call ptr addrspace(5) @malloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Texture], ptr addrspace(5) null, i32 1) to i32))
  store ptr addrspace(5) %calltmp, ptr %result, align 8
  %channels = alloca i32, align 4
  %readtmp = load ptr addrspace(5), ptr %file, align 8
  %readtmp1 = load ptr addrspace(5), ptr %result, align 8
  %1 = getelementptr inbounds %Texture, ptr addrspace(5) %readtmp1, i32 0, i32 1
  %2 = getelementptr inbounds %IVec2, ptr addrspace(5) %1, i32 0, i32 0
  %readtmp2 = load ptr addrspace(5), ptr %result, align 8
  %3 = getelementptr inbounds %Texture, ptr addrspace(5) %readtmp2, i32 0, i32 1
  %4 = getelementptr inbounds %IVec2, ptr addrspace(5) %3, i32 0, i32 1
  %calltmp3 = call ptr addrspace(5) @stbi_load(ptr addrspace(5) %readtmp, ptr addrspace(5) %2, ptr addrspace(5) %4, ptr %channels, i32 4)
  store ptr addrspace(5) %calltmp3, ptr %data, align 8
  %readtmp4 = load ptr addrspace(5), ptr %result, align 8
  %5 = getelementptr inbounds %Texture, ptr addrspace(5) %readtmp4, i32 0, i32 0
  %calltmp5 = call void @glGenTextures(i32 1, ptr addrspace(5) %5)
  %readtmp6 = load ptr addrspace(5), ptr %result, align 8
  %6 = getelementptr inbounds %Texture, ptr addrspace(5) %readtmp6, i32 0, i32 0
  %readtmp7 = load i32, ptr addrspace(5) %6, align 4
  %calltmp8 = call void @glBindTexture(i32 3553, i32 %readtmp7)
  %calltmp9 = call void @glTexParameteri(i32 3553, i32 10241, i32 9728)
  %calltmp10 = call void @glTexParameteri(i32 3553, i32 10240, i32 9728)
  %readtmp11 = load ptr addrspace(5), ptr %result, align 8
  %7 = getelementptr inbounds %Texture, ptr addrspace(5) %readtmp11, i32 0, i32 1
  %8 = getelementptr inbounds %IVec2, ptr addrspace(5) %7, i32 0, i32 0
  %readtmp12 = load i32, ptr addrspace(5) %8, align 4
  %readtmp13 = load ptr addrspace(5), ptr %result, align 8
  %9 = getelementptr inbounds %Texture, ptr addrspace(5) %readtmp13, i32 0, i32 1
  %10 = getelementptr inbounds %IVec2, ptr addrspace(5) %9, i32 0, i32 1
  %readtmp14 = load i32, ptr addrspace(5) %10, align 4
  %readtmp15 = load ptr addrspace(5), ptr %data, align 8
  %calltmp16 = call void @glTexImage2D(i32 3553, i32 0, i32 6408, i32 %readtmp12, i32 %readtmp14, i32 0, i32 6408, i32 5121, ptr addrspace(5) %readtmp15)
  %calltmp17 = call void @glGenerateMipmap(i32 3553)
  %readtmp18 = load ptr addrspace(5), ptr %data, align 8
  %calltmp19 = call void @stbi_image_free(ptr addrspace(5) %readtmp18)
  %readtmp20 = load ptr addrspace(5), ptr %result, align 8
  ret ptr addrspace(5) %readtmp20
  %calltmp21 = call ptr addrspace(5) @Texture.new_0(ptr @str.7)
  store ptr addrspace(5) %calltmp21, ptr %elemtemp, align 8
  %11 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 2
  %elemtemp = getelementptr inbounds [2 x ptr addrspace(5)], ptr %11, i32 0, i32 1
  %calltmp22 = call ptr addrspace(5) @Texture.new_0(ptr @str.8)
  store ptr addrspace(5) %calltmp22, ptr %elemtemp, align 8
  %12 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 1
  %13 = getelementptr inbounds %MultiSprite, ptr %12, i32 0, i32 0
  %14 = getelementptr inbounds %Vec2, ptr %13, i32 0, i32 0
  store float 6.400000e+01, ptr %14, align 4
  %15 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 1
  %16 = getelementptr inbounds %MultiSprite, ptr %15, i32 0, i32 0
  %17 = getelementptr inbounds %Vec2, ptr %16, i32 0, i32 1
  store float 6.400000e+01, ptr %17, align 4
  %18 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 1
  %19 = getelementptr inbounds %MultiSprite, ptr %18, i32 0, i32 2
  %20 = getelementptr inbounds %Vec2, ptr %19, i32 0, i32 0
  store float 3.000000e+00, ptr %20, align 4
  %21 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 1
  %22 = getelementptr inbounds %MultiSprite, ptr %21, i32 0, i32 2
  %23 = getelementptr inbounds %Vec2, ptr %22, i32 0, i32 1
  store float 3.000000e+00, ptr %23, align 4
  %24 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 1
  %25 = getelementptr inbounds %MultiSprite, ptr %24, i32 0, i32 3
  %26 = getelementptr inbounds %Vec2, ptr %25, i32 0, i32 0
  store float 1.000000e+00, ptr %26, align 4
  %27 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 1
  %28 = getelementptr inbounds %MultiSprite, ptr %27, i32 0, i32 3
  %29 = getelementptr inbounds %Vec2, ptr %28, i32 0, i32 1
  store float 0.000000e+00, ptr %29, align 4
  %30 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 1
  %31 = getelementptr inbounds %MultiSprite, ptr %30, i32 0, i32 1
  %32 = getelementptr inbounds %Vec2, ptr %31, i32 0, i32 0
  store float 2.860000e+02, ptr %32, align 4
  %33 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 1
  %34 = getelementptr inbounds %MultiSprite, ptr %33, i32 0, i32 1
  %35 = getelementptr inbounds %Vec2, ptr %34, i32 0, i32 1
  store float 3.000000e+02, ptr %35, align 4
  %36 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 3
  %37 = getelementptr inbounds %Vec2, ptr %36, i32 0, i32 0
  store float 0.000000e+00, ptr %37, align 4
  %38 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 3
  %39 = getelementptr inbounds %Vec2, ptr %38, i32 0, i32 1
  store float 0.000000e+00, ptr %39, align 4
  %40 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 0
  %elemtemp23 = getelementptr inbounds [1 x %Drawer], ptr %40, i32 0, i32 0
  %41 = getelementptr inbounds %Drawer, ptr %elemtemp23, i32 0, i32 0
}

define ptr addrspace(5) @MultiSprite.getVerts_0(ptr addrspace(5) %0) {
entry:
  %self = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %self, align 8
  %v = alloca ptr addrspace(5), align 8
  %calltmp = call ptr addrspace(5) @malloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Verts], ptr addrspace(5) null, i32 1) to i32))
  store ptr addrspace(5) %calltmp, ptr %v, align 8
  %readtmp = load ptr addrspace(5), ptr %v, align 8
  %1 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp, i32 0, i32 0
  %calltmp1 = call ptr addrspace(5) @calloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Vert], ptr addrspace(5) null, i32 1) to i32), i64 6)
  store ptr addrspace(5) %calltmp1, ptr addrspace(5) %1, align 8
  %readtmp2 = load ptr addrspace(5), ptr %v, align 8
  %2 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp2, i32 0, i32 1
  store i32 6, ptr addrspace(5) %2, align 4
  %uv = alloca %Rect, align 8
  %readtmp3 = load ptr addrspace(5), ptr %self, align 8
  %3 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp3, i32 0, i32 2
  %4 = getelementptr inbounds %Vec2, ptr addrspace(5) %3, i32 0, i32 0
  %readtmp4 = load float, ptr addrspace(5) %4, align 4
  %divtmp = fdiv float 1.000000e+00, %readtmp4
  %readtmp5 = load ptr addrspace(5), ptr %self, align 8
  %5 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp5, i32 0, i32 3
  %readtmp6 = load %Vec2, ptr addrspace(5) %5, align 4
  %extracted = extractvalue %Vec2 %readtmp6, 0
  %multmp = fmul float %divtmp, %extracted
  %readtmp7 = load ptr addrspace(5), ptr %self, align 8
  %6 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp7, i32 0, i32 2
  %7 = getelementptr inbounds %Vec2, ptr addrspace(5) %6, i32 0, i32 1
  %readtmp8 = load float, ptr addrspace(5) %7, align 4
  %divtmp9 = fdiv float 1.000000e+00, %readtmp8
  %readtmp10 = load ptr addrspace(5), ptr %self, align 8
  %8 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp10, i32 0, i32 3
  %readtmp11 = load %Vec2, ptr addrspace(5) %8, align 4
  %extracted12 = extractvalue %Vec2 %readtmp11, 1
  %multmp13 = fmul float %divtmp9, %extracted12
  %readtmp14 = load ptr addrspace(5), ptr %self, align 8
  %9 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp14, i32 0, i32 2
  %10 = getelementptr inbounds %Vec2, ptr addrspace(5) %9, i32 0, i32 0
  %readtmp15 = load float, ptr addrspace(5) %10, align 4
  %divtmp16 = fdiv float 1.000000e+00, %readtmp15
  %readtmp17 = load ptr addrspace(5), ptr %self, align 8
  %11 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp17, i32 0, i32 2
  %12 = getelementptr inbounds %Vec2, ptr addrspace(5) %11, i32 0, i32 1
  %readtmp18 = load float, ptr addrspace(5) %12, align 4
  %divtmp19 = fdiv float 1.000000e+00, %readtmp18
}

define %Rect @Rect.new_0(float %0, float %1, float %2, float %3) {
entry:
  %result = alloca %Rect, align 8
  %4 = getelementptr inbounds %Rect, ptr %result, i32 0, i32 3
  store float %3, ptr %4, align 4
  %5 = getelementptr inbounds %Rect, ptr %result, i32 0, i32 2
  store float %2, ptr %5, align 4
  %6 = getelementptr inbounds %Rect, ptr %result, i32 0, i32 1
  store float %1, ptr %6, align 4
  %7 = getelementptr inbounds %Rect, ptr %result, i32 0, i32 0
  store float %0, ptr %7, align 4
  %readtmp = load %Rect, ptr %result, align 4
  ret %Rect %readtmp
  %calltmp = call %Rect @Rect.new_0(float %multmp, float %multmp13, float %divtmp16, float %divtmp19)
  store %Rect %calltmp, ptr %uv, align 4
  %readtmp1 = load ptr addrspace(5), ptr %v, align 8
  %8 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp1, i32 0, i32 0
  %readtmp2 = load ptr addrspace(5), ptr addrspace(5) %8, align 8
  %elemtemp = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp2, i32 0, i32 0
  %9 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp, i32 0, i32 0
  %readtmp3 = load ptr addrspace(5), ptr %self, align 8
  %10 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp3, i32 0, i32 1
  %11 = getelementptr inbounds %Vec2, ptr addrspace(5) %10, i32 0, i32 0
  %readtmp4 = load float, ptr addrspace(5) %11, align 4
  store float %readtmp4, ptr addrspace(5) %9, align 4
  %readtmp5 = load ptr addrspace(5), ptr %v, align 8
  %12 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp5, i32 0, i32 0
  %readtmp6 = load ptr addrspace(5), ptr addrspace(5) %12, align 8
  %elemtemp7 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp6, i32 0, i32 0
  %13 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp7, i32 0, i32 1
  %readtmp8 = load ptr addrspace(5), ptr %self, align 8
  %14 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp8, i32 0, i32 1
  %15 = getelementptr inbounds %Vec2, ptr addrspace(5) %14, i32 0, i32 1
  %readtmp9 = load float, ptr addrspace(5) %15, align 4
  store float %readtmp9, ptr addrspace(5) %13, align 4
  %readtmp10 = load ptr addrspace(5), ptr %v, align 8
  %16 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp10, i32 0, i32 0
  %readtmp11 = load ptr addrspace(5), ptr addrspace(5) %16, align 8
  %elemtemp12 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp11, i32 0, i32 0
  %17 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp12, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %17, align 4
  %readtmp13 = load ptr addrspace(5), ptr %v, align 8
  %18 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp13, i32 0, i32 0
  %readtmp14 = load ptr addrspace(5), ptr addrspace(5) %18, align 8
  %elemtemp15 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp14, i32 0, i32 0
  %19 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp15, i32 0, i32 3
  %20 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 0
  %readtmp16 = load float, ptr %20, align 4
  store float %readtmp16, ptr addrspace(5) %19, align 4
  %readtmp17 = load ptr addrspace(5), ptr %v, align 8
  %21 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp17, i32 0, i32 0
  %readtmp18 = load ptr addrspace(5), ptr addrspace(5) %21, align 8
  %elemtemp19 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp18, i32 0, i32 0
  %22 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp19, i32 0, i32 4
  %23 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 1
  %readtmp20 = load float, ptr %23, align 4
  store float %readtmp20, ptr addrspace(5) %22, align 4
  %readtmp21 = load ptr addrspace(5), ptr %v, align 8
  %24 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp21, i32 0, i32 0
  %readtmp22 = load ptr addrspace(5), ptr addrspace(5) %24, align 8
  %elemtemp23 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp22, i32 0, i32 1
  %25 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp23, i32 0, i32 0
  %readtmp24 = load ptr addrspace(5), ptr %self, align 8
  %26 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp24, i32 0, i32 1
  %27 = getelementptr inbounds %Vec2, ptr addrspace(5) %26, i32 0, i32 0
  %readtmp25 = load float, ptr addrspace(5) %27, align 4
  %readtmp26 = load ptr addrspace(5), ptr %self, align 8
  %28 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp26, i32 0, i32 0
  %29 = getelementptr inbounds %Vec2, ptr addrspace(5) %28, i32 0, i32 0
  %readtmp27 = load float, ptr addrspace(5) %29, align 4
  %addtmp = fadd float %readtmp25, %readtmp27
  store float %addtmp, ptr addrspace(5) %25, align 4
  %readtmp28 = load ptr addrspace(5), ptr %v, align 8
  %30 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp28, i32 0, i32 0
  %readtmp29 = load ptr addrspace(5), ptr addrspace(5) %30, align 8
  %elemtemp30 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp29, i32 0, i32 1
  %31 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp30, i32 0, i32 1
  %readtmp31 = load ptr addrspace(5), ptr %self, align 8
  %32 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp31, i32 0, i32 1
  %33 = getelementptr inbounds %Vec2, ptr addrspace(5) %32, i32 0, i32 1
  %readtmp32 = load float, ptr addrspace(5) %33, align 4
  %readtmp33 = load ptr addrspace(5), ptr %self, align 8
  %34 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp33, i32 0, i32 0
  %35 = getelementptr inbounds %Vec2, ptr addrspace(5) %34, i32 0, i32 1
  %readtmp34 = load float, ptr addrspace(5) %35, align 4
  %addtmp35 = fadd float %readtmp32, %readtmp34
  store float %addtmp35, ptr addrspace(5) %31, align 4
  %readtmp36 = load ptr addrspace(5), ptr %v, align 8
  %36 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp36, i32 0, i32 0
  %readtmp37 = load ptr addrspace(5), ptr addrspace(5) %36, align 8
  %elemtemp38 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp37, i32 0, i32 1
  %37 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp38, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %37, align 4
  %readtmp39 = load ptr addrspace(5), ptr %v, align 8
  %38 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp39, i32 0, i32 0
  %readtmp40 = load ptr addrspace(5), ptr addrspace(5) %38, align 8
  %elemtemp41 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp40, i32 0, i32 1
  %39 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp41, i32 0, i32 3
  %40 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 0
  %readtmp42 = load float, ptr %40, align 4
  %41 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 2
  %readtmp43 = load float, ptr %41, align 4
  %addtmp44 = fadd float %readtmp42, %readtmp43
  store float %addtmp44, ptr addrspace(5) %39, align 4
  %readtmp45 = load ptr addrspace(5), ptr %v, align 8
  %42 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp45, i32 0, i32 0
  %readtmp46 = load ptr addrspace(5), ptr addrspace(5) %42, align 8
  %elemtemp47 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp46, i32 0, i32 1
  %43 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp47, i32 0, i32 4
  %44 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 1
  %readtmp48 = load float, ptr %44, align 4
  %45 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 3
  %readtmp49 = load float, ptr %45, align 4
  %addtmp50 = fadd float %readtmp48, %readtmp49
  store float %addtmp50, ptr addrspace(5) %43, align 4
  %readtmp51 = load ptr addrspace(5), ptr %v, align 8
  %46 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp51, i32 0, i32 0
  %readtmp52 = load ptr addrspace(5), ptr addrspace(5) %46, align 8
  %elemtemp53 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp52, i32 0, i32 2
  %47 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp53, i32 0, i32 0
  %readtmp54 = load ptr addrspace(5), ptr %self, align 8
  %48 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp54, i32 0, i32 1
  %49 = getelementptr inbounds %Vec2, ptr addrspace(5) %48, i32 0, i32 0
  %readtmp55 = load float, ptr addrspace(5) %49, align 4
  store float %readtmp55, ptr addrspace(5) %47, align 4
  %readtmp56 = load ptr addrspace(5), ptr %v, align 8
  %50 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp56, i32 0, i32 0
  %readtmp57 = load ptr addrspace(5), ptr addrspace(5) %50, align 8
  %elemtemp58 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp57, i32 0, i32 2
  %51 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp58, i32 0, i32 1
  %readtmp59 = load ptr addrspace(5), ptr %self, align 8
  %52 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp59, i32 0, i32 1
  %53 = getelementptr inbounds %Vec2, ptr addrspace(5) %52, i32 0, i32 1
  %readtmp60 = load float, ptr addrspace(5) %53, align 4
  %readtmp61 = load ptr addrspace(5), ptr %self, align 8
  %54 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp61, i32 0, i32 0
  %55 = getelementptr inbounds %Vec2, ptr addrspace(5) %54, i32 0, i32 1
  %readtmp62 = load float, ptr addrspace(5) %55, align 4
  %addtmp63 = fadd float %readtmp60, %readtmp62
  store float %addtmp63, ptr addrspace(5) %51, align 4
  %readtmp64 = load ptr addrspace(5), ptr %v, align 8
  %56 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp64, i32 0, i32 0
  %readtmp65 = load ptr addrspace(5), ptr addrspace(5) %56, align 8
  %elemtemp66 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp65, i32 0, i32 2
  %57 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp66, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %57, align 4
  %readtmp67 = load ptr addrspace(5), ptr %v, align 8
  %58 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp67, i32 0, i32 0
  %readtmp68 = load ptr addrspace(5), ptr addrspace(5) %58, align 8
  %elemtemp69 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp68, i32 0, i32 2
  %59 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp69, i32 0, i32 3
  %60 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 0
  %readtmp70 = load float, ptr %60, align 4
  store float %readtmp70, ptr addrspace(5) %59, align 4
  %readtmp71 = load ptr addrspace(5), ptr %v, align 8
  %61 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp71, i32 0, i32 0
  %readtmp72 = load ptr addrspace(5), ptr addrspace(5) %61, align 8
  %elemtemp73 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp72, i32 0, i32 2
  %62 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp73, i32 0, i32 4
  %63 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 1
  %readtmp74 = load float, ptr %63, align 4
  %64 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 3
  %readtmp75 = load float, ptr %64, align 4
  %addtmp76 = fadd float %readtmp74, %readtmp75
  store float %addtmp76, ptr addrspace(5) %62, align 4
  %readtmp77 = load ptr addrspace(5), ptr %v, align 8
  %65 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp77, i32 0, i32 0
  %readtmp78 = load ptr addrspace(5), ptr addrspace(5) %65, align 8
  %elemtemp79 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp78, i32 0, i32 3
  %66 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp79, i32 0, i32 0
  %readtmp80 = load ptr addrspace(5), ptr %self, align 8
  %67 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp80, i32 0, i32 1
  %68 = getelementptr inbounds %Vec2, ptr addrspace(5) %67, i32 0, i32 0
  %readtmp81 = load float, ptr addrspace(5) %68, align 4
  store float %readtmp81, ptr addrspace(5) %66, align 4
  %readtmp82 = load ptr addrspace(5), ptr %v, align 8
  %69 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp82, i32 0, i32 0
  %readtmp83 = load ptr addrspace(5), ptr addrspace(5) %69, align 8
  %elemtemp84 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp83, i32 0, i32 3
  %70 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp84, i32 0, i32 1
  %readtmp85 = load ptr addrspace(5), ptr %self, align 8
  %71 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp85, i32 0, i32 1
  %72 = getelementptr inbounds %Vec2, ptr addrspace(5) %71, i32 0, i32 1
  %readtmp86 = load float, ptr addrspace(5) %72, align 4
  store float %readtmp86, ptr addrspace(5) %70, align 4
  %readtmp87 = load ptr addrspace(5), ptr %v, align 8
  %73 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp87, i32 0, i32 0
  %readtmp88 = load ptr addrspace(5), ptr addrspace(5) %73, align 8
  %elemtemp89 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp88, i32 0, i32 3
  %74 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp89, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %74, align 4
  %readtmp90 = load ptr addrspace(5), ptr %v, align 8
  %75 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp90, i32 0, i32 0
  %readtmp91 = load ptr addrspace(5), ptr addrspace(5) %75, align 8
  %elemtemp92 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp91, i32 0, i32 3
  %76 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp92, i32 0, i32 3
  %77 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 0
  %readtmp93 = load float, ptr %77, align 4
  store float %readtmp93, ptr addrspace(5) %76, align 4
  %readtmp94 = load ptr addrspace(5), ptr %v, align 8
  %78 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp94, i32 0, i32 0
  %readtmp95 = load ptr addrspace(5), ptr addrspace(5) %78, align 8
  %elemtemp96 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp95, i32 0, i32 3
  %79 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp96, i32 0, i32 4
  %80 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 1
  %readtmp97 = load float, ptr %80, align 4
  store float %readtmp97, ptr addrspace(5) %79, align 4
  %readtmp98 = load ptr addrspace(5), ptr %v, align 8
  %81 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp98, i32 0, i32 0
  %readtmp99 = load ptr addrspace(5), ptr addrspace(5) %81, align 8
  %elemtemp100 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp99, i32 0, i32 4
  %82 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp100, i32 0, i32 0
  %readtmp101 = load ptr addrspace(5), ptr %self, align 8
  %83 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp101, i32 0, i32 1
  %84 = getelementptr inbounds %Vec2, ptr addrspace(5) %83, i32 0, i32 0
  %readtmp102 = load float, ptr addrspace(5) %84, align 4
  %readtmp103 = load ptr addrspace(5), ptr %self, align 8
  %85 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp103, i32 0, i32 0
  %86 = getelementptr inbounds %Vec2, ptr addrspace(5) %85, i32 0, i32 0
  %readtmp104 = load float, ptr addrspace(5) %86, align 4
  %addtmp105 = fadd float %readtmp102, %readtmp104
  store float %addtmp105, ptr addrspace(5) %82, align 4
  %readtmp106 = load ptr addrspace(5), ptr %v, align 8
  %87 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp106, i32 0, i32 0
  %readtmp107 = load ptr addrspace(5), ptr addrspace(5) %87, align 8
  %elemtemp108 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp107, i32 0, i32 4
  %88 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp108, i32 0, i32 1
  %readtmp109 = load ptr addrspace(5), ptr %self, align 8
  %89 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp109, i32 0, i32 1
  %90 = getelementptr inbounds %Vec2, ptr addrspace(5) %89, i32 0, i32 1
  %readtmp110 = load float, ptr addrspace(5) %90, align 4
  %readtmp111 = load ptr addrspace(5), ptr %self, align 8
  %91 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp111, i32 0, i32 0
  %92 = getelementptr inbounds %Vec2, ptr addrspace(5) %91, i32 0, i32 1
  %readtmp112 = load float, ptr addrspace(5) %92, align 4
  %addtmp113 = fadd float %readtmp110, %readtmp112
  store float %addtmp113, ptr addrspace(5) %88, align 4
  %readtmp114 = load ptr addrspace(5), ptr %v, align 8
  %93 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp114, i32 0, i32 0
  %readtmp115 = load ptr addrspace(5), ptr addrspace(5) %93, align 8
  %elemtemp116 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp115, i32 0, i32 4
  %94 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp116, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %94, align 4
  %readtmp117 = load ptr addrspace(5), ptr %v, align 8
  %95 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp117, i32 0, i32 0
  %readtmp118 = load ptr addrspace(5), ptr addrspace(5) %95, align 8
  %elemtemp119 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp118, i32 0, i32 4
  %96 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp119, i32 0, i32 3
  %97 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 0
  %readtmp120 = load float, ptr %97, align 4
  %98 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 2
  %readtmp121 = load float, ptr %98, align 4
  %addtmp122 = fadd float %readtmp120, %readtmp121
  store float %addtmp122, ptr addrspace(5) %96, align 4
  %readtmp123 = load ptr addrspace(5), ptr %v, align 8
  %99 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp123, i32 0, i32 0
  %readtmp124 = load ptr addrspace(5), ptr addrspace(5) %99, align 8
  %elemtemp125 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp124, i32 0, i32 4
  %100 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp125, i32 0, i32 4
  %101 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 1
  %readtmp126 = load float, ptr %101, align 4
  %102 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 3
  %readtmp127 = load float, ptr %102, align 4
  %addtmp128 = fadd float %readtmp126, %readtmp127
  store float %addtmp128, ptr addrspace(5) %100, align 4
  %readtmp129 = load ptr addrspace(5), ptr %v, align 8
  %103 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp129, i32 0, i32 0
  %readtmp130 = load ptr addrspace(5), ptr addrspace(5) %103, align 8
  %elemtemp131 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp130, i32 0, i32 5
  %104 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp131, i32 0, i32 0
  %readtmp132 = load ptr addrspace(5), ptr %self, align 8
  %105 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp132, i32 0, i32 1
  %106 = getelementptr inbounds %Vec2, ptr addrspace(5) %105, i32 0, i32 0
  %readtmp133 = load float, ptr addrspace(5) %106, align 4
  %readtmp134 = load ptr addrspace(5), ptr %self, align 8
  %107 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp134, i32 0, i32 0
  %108 = getelementptr inbounds %Vec2, ptr addrspace(5) %107, i32 0, i32 0
  %readtmp135 = load float, ptr addrspace(5) %108, align 4
  %addtmp136 = fadd float %readtmp133, %readtmp135
  store float %addtmp136, ptr addrspace(5) %104, align 4
  %readtmp137 = load ptr addrspace(5), ptr %v, align 8
  %109 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp137, i32 0, i32 0
  %readtmp138 = load ptr addrspace(5), ptr addrspace(5) %109, align 8
  %elemtemp139 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp138, i32 0, i32 5
  %110 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp139, i32 0, i32 1
  %readtmp140 = load ptr addrspace(5), ptr %self, align 8
  %111 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %readtmp140, i32 0, i32 1
  %112 = getelementptr inbounds %Vec2, ptr addrspace(5) %111, i32 0, i32 1
  %readtmp141 = load float, ptr addrspace(5) %112, align 4
  store float %readtmp141, ptr addrspace(5) %110, align 4
  %readtmp142 = load ptr addrspace(5), ptr %v, align 8
  %113 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp142, i32 0, i32 0
  %readtmp143 = load ptr addrspace(5), ptr addrspace(5) %113, align 8
  %elemtemp144 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp143, i32 0, i32 5
  %114 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp144, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %114, align 4
  %readtmp145 = load ptr addrspace(5), ptr %v, align 8
  %115 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp145, i32 0, i32 0
  %readtmp146 = load ptr addrspace(5), ptr addrspace(5) %115, align 8
  %elemtemp147 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp146, i32 0, i32 5
  %116 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp147, i32 0, i32 3
  %117 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 0
  %readtmp148 = load float, ptr %117, align 4
  %118 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 2
  %readtmp149 = load float, ptr %118, align 4
  %addtmp150 = fadd float %readtmp148, %readtmp149
  store float %addtmp150, ptr addrspace(5) %116, align 4
  %readtmp151 = load ptr addrspace(5), ptr %v, align 8
  %119 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp151, i32 0, i32 0
  %readtmp152 = load ptr addrspace(5), ptr addrspace(5) %119, align 8
  %elemtemp153 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp152, i32 0, i32 5
  %120 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp153, i32 0, i32 4
  %121 = getelementptr inbounds %Rect, ptr %uv, i32 0, i32 1
  %readtmp154 = load float, ptr %121, align 4
  store float %readtmp154, ptr addrspace(5) %120, align 4
  %readtmp155 = load ptr addrspace(5), ptr %v, align 8
  ret ptr addrspace(5) %readtmp155
  store ptr @MultiSprite.getVerts_0, ptr %41, align 8
  %122 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 0
  %elemtemp156 = getelementptr inbounds [1 x %Drawer], ptr %122, i32 0, i32 0
  %123 = getelementptr inbounds %Drawer, ptr %elemtemp156, i32 0, i32 1
  %124 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 2
  %elemtemp157 = getelementptr inbounds [2 x ptr addrspace(5)], ptr %124, i32 0, i32 0
  %readtmp158 = load ptr addrspace(5), ptr %elemtemp157, align 8
  store ptr addrspace(5) %readtmp158, ptr %123, align 8
  %125 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 0
  %elemtemp159 = getelementptr inbounds [1 x %Drawer], ptr %125, i32 0, i32 0
  %126 = getelementptr inbounds %Drawer, ptr %elemtemp159, i32 0, i32 2
  %elemtemp160 = getelementptr inbounds [2 x ptr addrspace(5)], ptr %shd, i32 0, i32 0
  %readtmp161 = load ptr addrspace(5), ptr %elemtemp160, align 8
  store ptr addrspace(5) %readtmp161, ptr %126, align 8
  %127 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 4
  %128 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 2
  %elemtemp162 = getelementptr inbounds [2 x ptr addrspace(5)], ptr %128, i32 0, i32 1
  %readtmp163 = load ptr addrspace(5), ptr %elemtemp162, align 8
  %elemtemp164 = getelementptr inbounds [2 x ptr addrspace(5)], ptr %shd, i32 0, i32 0
  %readtmp165 = load ptr addrspace(5), ptr %elemtemp164, align 8
}

define %BulletManager @BulletManager.new_0(ptr addrspace(5) %0, ptr addrspace(5) %1) {
entry:
  %result = alloca %BulletManager, align 8
  %2 = getelementptr inbounds %BulletManager, ptr %result, i32 0, i32 1
  store i32 0, ptr %2, align 4
  %3 = getelementptr inbounds %BulletManager, ptr %result, i32 0, i32 0
  %calltmp = call ptr addrspace(5) @malloc(i64 10)
  store ptr addrspace(5) %calltmp, ptr %3, align 8
  %4 = getelementptr inbounds %BulletManager, ptr %result, i32 0, i32 3
  store ptr addrspace(5) %1, ptr %4, align 8
  %5 = getelementptr inbounds %BulletManager, ptr %result, i32 0, i32 2
  store ptr addrspace(5) %0, ptr %5, align 8
  %readtmp = load %BulletManager, ptr %result, align 8
  ret %BulletManager %readtmp
  %calltmp1 = call %BulletManager @BulletManager.new_0(ptr addrspace(5) %readtmp163, ptr addrspace(5) %readtmp165)
  store %BulletManager %calltmp1, ptr %127, align 8
  %6 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 5
  %elemtemp = getelementptr inbounds [2 x ptr addrspace(5)], ptr %shd, i32 0, i32 1
  %readtmp2 = load ptr addrspace(5), ptr %elemtemp, align 8
}

define %Stars @Stars.init_0(ptr addrspace(5) %0) {
entry:
  %shader = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %shader, align 8
  %result = alloca %Stars, align 8
  %calltmp = call void @setuprand()
  %idx = alloca i32, align 4
  store i32 0, ptr %idx, align 4
  br label %dobody

dobody:                                           ; preds = %entry, %entry
  %1 = getelementptr inbounds %Stars, ptr %result, i32 0, i32 1
  %readtmp = load i32, ptr %idx, align 4
  %multmp = mul i32 %readtmp, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Star], ptr addrspace(5) null, i32 1) to i32)

domerge:                                          ; preds = %entry
  %2 = getelementptr inbounds %Stars, ptr %result, i32 0, i32 0
  %calltmp1 = call void @glGenBuffers(i32 1, ptr %2)
  %3 = getelementptr inbounds %Stars, ptr %result, i32 0, i32 2
  %4 = getelementptr inbounds %Drawer, ptr %3, i32 0, i32 0
}

define ptr addrspace(5) @mem.add_0(ptr addrspace(5) %0, i64 %1) {
entry:
  %addtmp = add i64 %1, ptr addrspace(5) %0
  ret i64 %addtmp
  %calltmp = call ptr addrspace(5) @mem.add_0(ptr %1, i32 %multmp)
  %2 = getelementptr inbounds %Star, ptr addrspace(5) %calltmp, i32 0, i32 2
  %calltmp1 = call float @randf()
  %multmp = fmul float %calltmp1, 6.400000e+02
  %calltmp2 = call float @randf()
  %multmp3 = fmul float %calltmp2, 4.800000e+02
  %calltmp4 = call %Vec2 @Vec2.new_0(float %multmp, float %multmp3)
  store %Vec2 %calltmp4, ptr addrspace(5) %2, align 4
  %3 = getelementptr inbounds %Stars, ptr %result, i32 0, i32 1
  %readtmp = load i32, ptr %idx, align 4
  %multmp5 = mul i32 %readtmp, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Star], ptr addrspace(5) null, i32 1) to i32)
  %calltmp6 = call ptr addrspace(5) @mem.add_0(ptr %3, i32 %multmp5)
  %4 = getelementptr inbounds %Star, ptr addrspace(5) %calltmp6, i32 0, i32 0
  %calltmp7 = call float @randf()
  %multmp8 = fmul float %calltmp7, 1.000000e+01
  %addtmp9 = fadd float %multmp8, 3.000000e+00
  store float %addtmp9, ptr addrspace(5) %4, align 4
  %5 = getelementptr inbounds %Stars, ptr %result, i32 0, i32 1
  %readtmp10 = load i32, ptr %idx, align 4
  %multmp11 = mul i32 %readtmp10, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Star], ptr addrspace(5) null, i32 1) to i32)
  %calltmp12 = call ptr addrspace(5) @mem.add_0(ptr %5, i32 %multmp11)
  %6 = getelementptr inbounds %Star, ptr addrspace(5) %calltmp12, i32 0, i32 3
}

define %Color @Color.new_0(float %0, float %1, float %2, float %3) {
entry:
  %result = alloca %Color, align 8
  %4 = getelementptr inbounds %Color, ptr %result, i32 0, i32 3
  store float %3, ptr %4, align 4
  %5 = getelementptr inbounds %Color, ptr %result, i32 0, i32 2
  store float %2, ptr %5, align 4
  %6 = getelementptr inbounds %Color, ptr %result, i32 0, i32 1
  store float %1, ptr %6, align 4
  %7 = getelementptr inbounds %Color, ptr %result, i32 0, i32 0
  store float %0, ptr %7, align 4
  %readtmp = load %Color, ptr %result, align 4
  ret %Color %readtmp
  %calltmp = call %Color @Color.new_0(float 0x3FE3333340000000, float 0x3FE6666660000000, float 0.000000e+00, float 1.000000e+00)
  %calltmp1 = call %Color @Color.new_0(float 1.000000e+00, float 0.000000e+00, float 0.000000e+00, float 1.000000e+00)
  %calltmp2 = call float @randf()
}

define %Color @Color.mix_0(%Color %0, %Color %1, float %2) {
entry:
  %pc = alloca float, align 4
  %a = alloca %Color, align 8
  %b = alloca %Color, align 8
  %result = alloca %Color, align 8
  store float %2, ptr %pc, align 4
  store %Color %1, ptr %b, align 4
  store %Color %0, ptr %a, align 4
  %3 = getelementptr inbounds %Color, ptr %result, i32 0, i32 0
  %4 = getelementptr inbounds %Color, ptr %a, i32 0, i32 0
  %readtmp = load float, ptr %4, align 4
  %readtmp1 = load float, ptr %pc, align 4
  %multmp = fmul float %readtmp, %readtmp1
  %5 = getelementptr inbounds %Color, ptr %b, i32 0, i32 0
  %readtmp2 = load float, ptr %5, align 4
  %readtmp3 = load float, ptr %pc, align 4
  %subtmp = fsub float 1.000000e+00, %readtmp3
  %multmp4 = fmul float %readtmp2, %subtmp
  %addtmp = fadd float %multmp, %multmp4
  store float %addtmp, ptr %3, align 4
  %6 = getelementptr inbounds %Color, ptr %result, i32 0, i32 1
  %7 = getelementptr inbounds %Color, ptr %a, i32 0, i32 1
  %readtmp5 = load float, ptr %7, align 4
  %readtmp6 = load float, ptr %pc, align 4
  %multmp7 = fmul float %readtmp5, %readtmp6
  %8 = getelementptr inbounds %Color, ptr %b, i32 0, i32 1
  %readtmp8 = load float, ptr %8, align 4
  %readtmp9 = load float, ptr %pc, align 4
  %subtmp10 = fsub float 1.000000e+00, %readtmp9
  %multmp11 = fmul float %readtmp8, %subtmp10
  %addtmp12 = fadd float %multmp7, %multmp11
  store float %addtmp12, ptr %6, align 4
  %9 = getelementptr inbounds %Color, ptr %result, i32 0, i32 2
  %10 = getelementptr inbounds %Color, ptr %a, i32 0, i32 2
  %readtmp13 = load float, ptr %10, align 4
  %readtmp14 = load float, ptr %pc, align 4
  %multmp15 = fmul float %readtmp13, %readtmp14
  %11 = getelementptr inbounds %Color, ptr %b, i32 0, i32 2
  %readtmp16 = load float, ptr %11, align 4
  %readtmp17 = load float, ptr %pc, align 4
  %subtmp18 = fsub float 1.000000e+00, %readtmp17
  %multmp19 = fmul float %readtmp16, %subtmp18
  %addtmp20 = fadd float %multmp15, %multmp19
  store float %addtmp20, ptr %9, align 4
  %12 = getelementptr inbounds %Color, ptr %result, i32 0, i32 3
  %13 = getelementptr inbounds %Color, ptr %a, i32 0, i32 3
  %readtmp21 = load float, ptr %13, align 4
  %readtmp22 = load float, ptr %pc, align 4
  %multmp23 = fmul float %readtmp21, %readtmp22
  %14 = getelementptr inbounds %Color, ptr %b, i32 0, i32 3
  %readtmp24 = load float, ptr %14, align 4
  %readtmp25 = load float, ptr %pc, align 4
  %subtmp26 = fsub float 1.000000e+00, %readtmp25
  %multmp27 = fmul float %readtmp24, %subtmp26
  %addtmp28 = fadd float %multmp23, %multmp27
  store float %addtmp28, ptr %12, align 4
  %readtmp29 = load %Color, ptr %result, align 4
  ret %Color %readtmp29
  %calltmp = call %Color @Color.mix_0(%Color %calltmp, %Color %calltmp1, float %calltmp2)
  %calltmp30 = call %Color @Color.new_0(float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00)
  %calltmp31 = call float @randf()
  %calltmp32 = call %Color @Color.mix_0(%Color %calltmp, %Color %calltmp30, float %calltmp31)
  store %Color %calltmp32, ptr addrspace(5) %6, align 4
  %readtmp33 = load i32, ptr %idx, align 4
  %addtmp34 = add i32 %readtmp33, 1
  store i32 %addtmp34, ptr %idx, align 4
  %readtmp35 = load i32, ptr %idx, align 4
  %lttmp = icmp ult i32 %readtmp35, 100
  %docond = icmp ne i1 %lttmp, false
  br i1 %docond, label %dobody, label %domerge
}

define ptr addrspace(5) @Stars.getVerts_0(ptr addrspace(5) %0) {
entry:
  %self = alloca ptr addrspace(5), align 8
  %toDraw = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %self, align 8
  %calltmp = call ptr addrspace(5) @malloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Verts], ptr addrspace(5) null, i32 1) to i32))
  store ptr addrspace(5) %calltmp, ptr %toDraw, align 8
  %readtmp = load ptr addrspace(5), ptr %toDraw, align 8
  %1 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp, i32 0, i32 0
  %calltmp1 = call ptr addrspace(5) @calloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Vert], ptr addrspace(5) null, i32 1) to i32), i64 600)
  store ptr addrspace(5) %calltmp1, ptr addrspace(5) %1, align 8
  %readtmp2 = load ptr addrspace(5), ptr %toDraw, align 8
  %2 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp2, i32 0, i32 1
  store i32 600, ptr addrspace(5) %2, align 4
  %idx = alloca i32, align 4
  store i32 0, ptr %idx, align 4
  br label %dobody

dobody:                                           ; preds = %entry, %entry
  %editing = alloca ptr addrspace(5), align 8
  %current = alloca ptr addrspace(5), align 8
  %readtmp3 = load ptr addrspace(5), ptr %toDraw, align 8
  %3 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp3, i32 0, i32 0
  %readtmp4 = load ptr addrspace(5), ptr addrspace(5) %3, align 8
  %readtmp5 = load i32, ptr %idx, align 4
  %multmp = mul i32 %readtmp5, mul (i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Vert], ptr addrspace(5) null, i32 1) to i32), i32 6)

domerge:                                          ; preds = %entry
  %readtmp6 = load ptr addrspace(5), ptr %toDraw, align 8
  ret ptr addrspace(5) %readtmp6
  store ptr @Stars.getVerts_0, ptr %4, align 8
  %4 = getelementptr inbounds %Stars, ptr %result, i32 0, i32 2
  %5 = getelementptr inbounds %Drawer, ptr %4, i32 0, i32 2
  %readtmp7 = load ptr addrspace(5), ptr %shader, align 8
  store ptr addrspace(5) %readtmp7, ptr %5, align 8
  %readtmp8 = load %Stars, ptr %result, align 8
  ret %Stars %readtmp8
  %calltmp9 = call %Stars @Stars.init_0(ptr addrspace(5) %readtmp2)
  store %Stars %calltmp9, ptr %6, align 8
  %readtmp10 = load %GameState, ptr %result, align 8
  ret %GameState %readtmp10
  %calltmp11 = call %GameState @GameState.init_0([2 x ptr addrspace(5)] %readtmp18)
  store %GameState %calltmp11, ptr %currState, align 8
  %readtmp12 = load %GameState, ptr %currState, align 8
  store %GameState %readtmp12, ptr %prevState, align 8
  %calltmp13 = call void @glEnable(i32 3089)
  br label %dobody
}

define ptr addrspace(5) @mem.add_1(ptr addrspace(5) %0, i64 %1) {
entry:
  %addtmp = add i64 %1, ptr addrspace(5) %0
  ret i64 %addtmp
  %calltmp = call ptr addrspace(5) @mem.add_1(ptr addrspace(5) %readtmp4, i32 %multmp)
  store ptr addrspace(5) %calltmp, ptr %editing, align 8
  %readtmp = load ptr addrspace(5), ptr %self, align 8
  %2 = getelementptr inbounds %Stars, ptr addrspace(5) %readtmp, i32 0, i32 1
  %readtmp1 = load i32, ptr %idx, align 4
  %multmp = mul i32 %readtmp1, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Star], ptr addrspace(5) null, i32 1) to i32)
  %calltmp2 = call ptr addrspace(5) @mem.add_0(ptr addrspace(5) %2, i32 %multmp)
  store ptr addrspace(5) %calltmp2, ptr %current, align 8
  %readtmp3 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp3, i32 0, i32 0
  %3 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp, i32 0, i32 0
  %readtmp4 = load ptr addrspace(5), ptr %current, align 8
  %4 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp4, i32 0, i32 2
  %5 = getelementptr inbounds %Vec2, ptr addrspace(5) %4, i32 0, i32 0
  %readtmp5 = load float, ptr addrspace(5) %5, align 4
  %addtmp6 = fadd float %readtmp5, 3.000000e+00
  store float %addtmp6, ptr addrspace(5) %3, align 4
  %readtmp7 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp8 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp7, i32 0, i32 0
  %6 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp8, i32 0, i32 1
  %readtmp9 = load ptr addrspace(5), ptr %current, align 8
  %7 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp9, i32 0, i32 2
  %8 = getelementptr inbounds %Vec2, ptr addrspace(5) %7, i32 0, i32 1
  %readtmp10 = load float, ptr addrspace(5) %8, align 4
  %readtmp11 = load ptr addrspace(5), ptr %current, align 8
  %9 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp11, i32 0, i32 0
  %readtmp12 = load float, ptr addrspace(5) %9, align 4
  %multmp13 = fmul float %readtmp12, 3.000000e+00
  %addtmp14 = fadd float %readtmp10, %multmp13
  store float %addtmp14, ptr addrspace(5) %6, align 4
  %readtmp15 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp16 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp15, i32 0, i32 0
  %10 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp16, i32 0, i32 5
  %readtmp17 = load ptr addrspace(5), ptr %current, align 8
  %11 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp17, i32 0, i32 3
  %12 = getelementptr inbounds %Color, ptr addrspace(5) %11, i32 0, i32 0
  %readtmp18 = load float, ptr addrspace(5) %12, align 4
  store float %readtmp18, ptr addrspace(5) %10, align 4
  %readtmp19 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp20 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp19, i32 0, i32 0
  %13 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp20, i32 0, i32 6
  %readtmp21 = load ptr addrspace(5), ptr %current, align 8
  %14 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp21, i32 0, i32 3
  %15 = getelementptr inbounds %Color, ptr addrspace(5) %14, i32 0, i32 1
  %readtmp22 = load float, ptr addrspace(5) %15, align 4
  store float %readtmp22, ptr addrspace(5) %13, align 4
  %readtmp23 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp24 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp23, i32 0, i32 0
  %16 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp24, i32 0, i32 7
  %readtmp25 = load ptr addrspace(5), ptr %current, align 8
  %17 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp25, i32 0, i32 3
  %18 = getelementptr inbounds %Color, ptr addrspace(5) %17, i32 0, i32 2
  %readtmp26 = load float, ptr addrspace(5) %18, align 4
  store float %readtmp26, ptr addrspace(5) %16, align 4
  %readtmp27 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp28 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp27, i32 0, i32 0
  %19 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp28, i32 0, i32 8
  store float 1.000000e+00, ptr addrspace(5) %19, align 4
  %readtmp29 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp30 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp29, i32 0, i32 1
  %20 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp30, i32 0, i32 0
  %readtmp31 = load ptr addrspace(5), ptr %current, align 8
  %21 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp31, i32 0, i32 2
  %22 = getelementptr inbounds %Vec2, ptr addrspace(5) %21, i32 0, i32 0
  %readtmp32 = load float, ptr addrspace(5) %22, align 4
  store float %readtmp32, ptr addrspace(5) %20, align 4
  %readtmp33 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp34 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp33, i32 0, i32 1
  %23 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp34, i32 0, i32 1
  %readtmp35 = load ptr addrspace(5), ptr %current, align 8
  %24 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp35, i32 0, i32 2
  %25 = getelementptr inbounds %Vec2, ptr addrspace(5) %24, i32 0, i32 1
  %readtmp36 = load float, ptr addrspace(5) %25, align 4
  store float %readtmp36, ptr addrspace(5) %23, align 4
  %readtmp37 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp38 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp37, i32 0, i32 1
  %26 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp38, i32 0, i32 8
  store float 0.000000e+00, ptr addrspace(5) %26, align 4
  %readtmp39 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp40 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp39, i32 0, i32 1
  %27 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp40, i32 0, i32 5
  %readtmp41 = load ptr addrspace(5), ptr %current, align 8
  %28 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp41, i32 0, i32 3
  %29 = getelementptr inbounds %Color, ptr addrspace(5) %28, i32 0, i32 0
  %readtmp42 = load float, ptr addrspace(5) %29, align 4
  store float %readtmp42, ptr addrspace(5) %27, align 4
  %readtmp43 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp44 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp43, i32 0, i32 1
  %30 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp44, i32 0, i32 6
  %readtmp45 = load ptr addrspace(5), ptr %current, align 8
  %31 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp45, i32 0, i32 3
  %32 = getelementptr inbounds %Color, ptr addrspace(5) %31, i32 0, i32 1
  %readtmp46 = load float, ptr addrspace(5) %32, align 4
  store float %readtmp46, ptr addrspace(5) %30, align 4
  %readtmp47 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp48 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp47, i32 0, i32 1
  %33 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp48, i32 0, i32 7
  %readtmp49 = load ptr addrspace(5), ptr %current, align 8
  %34 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp49, i32 0, i32 3
  %35 = getelementptr inbounds %Color, ptr addrspace(5) %34, i32 0, i32 2
  %readtmp50 = load float, ptr addrspace(5) %35, align 4
  store float %readtmp50, ptr addrspace(5) %33, align 4
  %readtmp51 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp52 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp51, i32 0, i32 2
  %36 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp52, i32 0, i32 0
  %readtmp53 = load ptr addrspace(5), ptr %current, align 8
  %37 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp53, i32 0, i32 2
  %38 = getelementptr inbounds %Vec2, ptr addrspace(5) %37, i32 0, i32 0
  %readtmp54 = load float, ptr addrspace(5) %38, align 4
  %addtmp55 = fadd float %readtmp54, 3.000000e+00
  store float %addtmp55, ptr addrspace(5) %36, align 4
  %readtmp56 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp57 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp56, i32 0, i32 2
  %39 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp57, i32 0, i32 1
  %readtmp58 = load ptr addrspace(5), ptr %current, align 8
  %40 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp58, i32 0, i32 2
  %41 = getelementptr inbounds %Vec2, ptr addrspace(5) %40, i32 0, i32 1
  %readtmp59 = load float, ptr addrspace(5) %41, align 4
  store float %readtmp59, ptr addrspace(5) %39, align 4
  %readtmp60 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp61 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp60, i32 0, i32 2
  %42 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp61, i32 0, i32 8
  store float 0.000000e+00, ptr addrspace(5) %42, align 4
  %readtmp62 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp63 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp62, i32 0, i32 2
  %43 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp63, i32 0, i32 5
  %readtmp64 = load ptr addrspace(5), ptr %current, align 8
  %44 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp64, i32 0, i32 3
  %45 = getelementptr inbounds %Color, ptr addrspace(5) %44, i32 0, i32 0
  %readtmp65 = load float, ptr addrspace(5) %45, align 4
  store float %readtmp65, ptr addrspace(5) %43, align 4
  %readtmp66 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp67 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp66, i32 0, i32 2
  %46 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp67, i32 0, i32 6
  %readtmp68 = load ptr addrspace(5), ptr %current, align 8
  %47 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp68, i32 0, i32 3
  %48 = getelementptr inbounds %Color, ptr addrspace(5) %47, i32 0, i32 1
  %readtmp69 = load float, ptr addrspace(5) %48, align 4
  store float %readtmp69, ptr addrspace(5) %46, align 4
  %readtmp70 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp71 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp70, i32 0, i32 2
  %49 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp71, i32 0, i32 7
  %readtmp72 = load ptr addrspace(5), ptr %current, align 8
  %50 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp72, i32 0, i32 3
  %51 = getelementptr inbounds %Color, ptr addrspace(5) %50, i32 0, i32 2
  %readtmp73 = load float, ptr addrspace(5) %51, align 4
  store float %readtmp73, ptr addrspace(5) %49, align 4
  %readtmp74 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp75 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp74, i32 0, i32 3
  %52 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp75, i32 0, i32 0
  %readtmp76 = load ptr addrspace(5), ptr %current, align 8
  %53 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp76, i32 0, i32 2
  %54 = getelementptr inbounds %Vec2, ptr addrspace(5) %53, i32 0, i32 0
  %readtmp77 = load float, ptr addrspace(5) %54, align 4
  %addtmp78 = fadd float %readtmp77, 3.000000e+00
  store float %addtmp78, ptr addrspace(5) %52, align 4
  %readtmp79 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp80 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp79, i32 0, i32 3
  %55 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp80, i32 0, i32 1
  %readtmp81 = load ptr addrspace(5), ptr %current, align 8
  %56 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp81, i32 0, i32 2
  %57 = getelementptr inbounds %Vec2, ptr addrspace(5) %56, i32 0, i32 1
  %readtmp82 = load float, ptr addrspace(5) %57, align 4
  %readtmp83 = load ptr addrspace(5), ptr %current, align 8
  %58 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp83, i32 0, i32 0
  %readtmp84 = load float, ptr addrspace(5) %58, align 4
  %multmp85 = fmul float %readtmp84, 3.000000e+00
  %addtmp86 = fadd float %readtmp82, %multmp85
  store float %addtmp86, ptr addrspace(5) %55, align 4
  %readtmp87 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp88 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp87, i32 0, i32 3
  %59 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp88, i32 0, i32 8
  store float 1.000000e+00, ptr addrspace(5) %59, align 4
  %readtmp89 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp90 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp89, i32 0, i32 3
  %60 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp90, i32 0, i32 5
  %readtmp91 = load ptr addrspace(5), ptr %current, align 8
  %61 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp91, i32 0, i32 3
  %62 = getelementptr inbounds %Color, ptr addrspace(5) %61, i32 0, i32 0
  %readtmp92 = load float, ptr addrspace(5) %62, align 4
  store float %readtmp92, ptr addrspace(5) %60, align 4
  %readtmp93 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp94 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp93, i32 0, i32 3
  %63 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp94, i32 0, i32 6
  %readtmp95 = load ptr addrspace(5), ptr %current, align 8
  %64 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp95, i32 0, i32 3
  %65 = getelementptr inbounds %Color, ptr addrspace(5) %64, i32 0, i32 1
  %readtmp96 = load float, ptr addrspace(5) %65, align 4
  store float %readtmp96, ptr addrspace(5) %63, align 4
  %readtmp97 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp98 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp97, i32 0, i32 3
  %66 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp98, i32 0, i32 7
  %readtmp99 = load ptr addrspace(5), ptr %current, align 8
  %67 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp99, i32 0, i32 3
  %68 = getelementptr inbounds %Color, ptr addrspace(5) %67, i32 0, i32 2
  %readtmp100 = load float, ptr addrspace(5) %68, align 4
  store float %readtmp100, ptr addrspace(5) %66, align 4
  %readtmp101 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp102 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp101, i32 0, i32 4
  %69 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp102, i32 0, i32 0
  %readtmp103 = load ptr addrspace(5), ptr %current, align 8
  %70 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp103, i32 0, i32 2
  %71 = getelementptr inbounds %Vec2, ptr addrspace(5) %70, i32 0, i32 0
  %readtmp104 = load float, ptr addrspace(5) %71, align 4
  store float %readtmp104, ptr addrspace(5) %69, align 4
  %readtmp105 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp106 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp105, i32 0, i32 4
  %72 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp106, i32 0, i32 1
  %readtmp107 = load ptr addrspace(5), ptr %current, align 8
  %73 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp107, i32 0, i32 2
  %74 = getelementptr inbounds %Vec2, ptr addrspace(5) %73, i32 0, i32 1
  %readtmp108 = load float, ptr addrspace(5) %74, align 4
  store float %readtmp108, ptr addrspace(5) %72, align 4
  %readtmp109 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp110 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp109, i32 0, i32 4
  %75 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp110, i32 0, i32 8
  store float 0.000000e+00, ptr addrspace(5) %75, align 4
  %readtmp111 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp112 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp111, i32 0, i32 4
  %76 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp112, i32 0, i32 5
  %readtmp113 = load ptr addrspace(5), ptr %current, align 8
  %77 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp113, i32 0, i32 3
  %78 = getelementptr inbounds %Color, ptr addrspace(5) %77, i32 0, i32 0
  %readtmp114 = load float, ptr addrspace(5) %78, align 4
  store float %readtmp114, ptr addrspace(5) %76, align 4
  %readtmp115 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp116 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp115, i32 0, i32 4
  %79 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp116, i32 0, i32 6
  %readtmp117 = load ptr addrspace(5), ptr %current, align 8
  %80 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp117, i32 0, i32 3
  %81 = getelementptr inbounds %Color, ptr addrspace(5) %80, i32 0, i32 1
  %readtmp118 = load float, ptr addrspace(5) %81, align 4
  store float %readtmp118, ptr addrspace(5) %79, align 4
  %readtmp119 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp120 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp119, i32 0, i32 4
  %82 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp120, i32 0, i32 7
  %readtmp121 = load ptr addrspace(5), ptr %current, align 8
  %83 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp121, i32 0, i32 3
  %84 = getelementptr inbounds %Color, ptr addrspace(5) %83, i32 0, i32 2
  %readtmp122 = load float, ptr addrspace(5) %84, align 4
  store float %readtmp122, ptr addrspace(5) %82, align 4
  %readtmp123 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp124 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp123, i32 0, i32 5
  %85 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp124, i32 0, i32 0
  %readtmp125 = load ptr addrspace(5), ptr %current, align 8
  %86 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp125, i32 0, i32 2
  %87 = getelementptr inbounds %Vec2, ptr addrspace(5) %86, i32 0, i32 0
  %readtmp126 = load float, ptr addrspace(5) %87, align 4
  store float %readtmp126, ptr addrspace(5) %85, align 4
  %readtmp127 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp128 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp127, i32 0, i32 5
  %88 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp128, i32 0, i32 1
  %readtmp129 = load ptr addrspace(5), ptr %current, align 8
  %89 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp129, i32 0, i32 2
  %90 = getelementptr inbounds %Vec2, ptr addrspace(5) %89, i32 0, i32 1
  %readtmp130 = load float, ptr addrspace(5) %90, align 4
  %readtmp131 = load ptr addrspace(5), ptr %current, align 8
  %91 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp131, i32 0, i32 0
  %readtmp132 = load float, ptr addrspace(5) %91, align 4
  %multmp133 = fmul float %readtmp132, 3.000000e+00
  %addtmp134 = fadd float %readtmp130, %multmp133
  store float %addtmp134, ptr addrspace(5) %88, align 4
  %readtmp135 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp136 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp135, i32 0, i32 5
  %92 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp136, i32 0, i32 8
  store float 1.000000e+00, ptr addrspace(5) %92, align 4
  %readtmp137 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp138 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp137, i32 0, i32 5
  %93 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp138, i32 0, i32 5
  %readtmp139 = load ptr addrspace(5), ptr %current, align 8
  %94 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp139, i32 0, i32 3
  %95 = getelementptr inbounds %Color, ptr addrspace(5) %94, i32 0, i32 0
  %readtmp140 = load float, ptr addrspace(5) %95, align 4
  store float %readtmp140, ptr addrspace(5) %93, align 4
  %readtmp141 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp142 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp141, i32 0, i32 5
  %96 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp142, i32 0, i32 6
  %readtmp143 = load ptr addrspace(5), ptr %current, align 8
  %97 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp143, i32 0, i32 3
  %98 = getelementptr inbounds %Color, ptr addrspace(5) %97, i32 0, i32 1
  %readtmp144 = load float, ptr addrspace(5) %98, align 4
  store float %readtmp144, ptr addrspace(5) %96, align 4
  %readtmp145 = load ptr addrspace(5), ptr %editing, align 8
  %elemtemp146 = getelementptr inbounds [6 x %Vert], ptr addrspace(5) %readtmp145, i32 0, i32 5
  %99 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp146, i32 0, i32 7
  %readtmp147 = load ptr addrspace(5), ptr %current, align 8
  %100 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp147, i32 0, i32 3
  %101 = getelementptr inbounds %Color, ptr addrspace(5) %100, i32 0, i32 2
  %readtmp148 = load float, ptr addrspace(5) %101, align 4
  store float %readtmp148, ptr addrspace(5) %99, align 4
  %readtmp149 = load i32, ptr %idx, align 4
  %addtmp150 = add i32 %readtmp149, 1
  store i32 %addtmp150, ptr %idx, align 4
  %readtmp151 = load i32, ptr %idx, align 4
  %lttmp = icmp ult i32 %readtmp151, 100
  %docond = icmp ne i1 %lttmp, false
  br i1 %docond, label %dobody, label %domerge
}

define void @GameState.free_0(%GameState %0) {
entry:
  %extracted = extractvalue %GameState %0, 4
}

define void @BulletManager.free_0(%BulletManager %0) {
entry:
  %extracted = extractvalue %BulletManager %0, 0
  %calltmp = call void @free(ptr addrspace(5) %extracted)
  ret void
  %calltmp1 = call void @BulletManager.free_0(%BulletManager %extracted)
  ret void
  %calltmp2 = call void @GameState.free_0(%GameState %readtmp13)
  %readtmp = load %GameState, ptr %currState, align 8
}

define %GameState @GameState.copy_0(%GameState %0) {
entry:
  %result = alloca %GameState, align 8
  %input = alloca %GameState, align 8
  store %GameState %0, ptr %input, align 8
  %readtmp = load %GameState, ptr %input, align 8
  store %GameState %readtmp, ptr %result, align 8
  %1 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 4
  %readtmp1 = load %GameState, ptr %input, align 8
  %extracted = extractvalue %GameState %readtmp1, 4
}

define %BulletManager @BulletManager.copy_0(%BulletManager %0) {
entry:
  %result = alloca %BulletManager, align 8
  %input = alloca %BulletManager, align 8
  store %BulletManager %0, ptr %input, align 8
  %1 = getelementptr inbounds %BulletManager, ptr %result, i32 0, i32 1
  %2 = getelementptr inbounds %BulletManager, ptr %input, i32 0, i32 1
  %readtmp = load i32, ptr %2, align 4
  store i32 %readtmp, ptr %1, align 4
  %3 = getelementptr inbounds %BulletManager, ptr %result, i32 0, i32 0
  %4 = getelementptr inbounds %BulletManager, ptr %input, i32 0, i32 1
  %readtmp1 = load i32, ptr %4, align 4
  %multmp = mul i32 %readtmp1, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Bullet], ptr addrspace(5) null, i32 1) to i32)
  %calltmp = call ptr addrspace(5) @malloc(i32 %multmp)
  store ptr addrspace(5) %calltmp, ptr %3, align 8
  %5 = getelementptr inbounds %BulletManager, ptr %result, i32 0, i32 3
  %6 = getelementptr inbounds %BulletManager, ptr %input, i32 0, i32 3
  %readtmp2 = load ptr addrspace(5), ptr %6, align 8
  store ptr addrspace(5) %readtmp2, ptr %5, align 8
  %7 = getelementptr inbounds %BulletManager, ptr %result, i32 0, i32 2
  %8 = getelementptr inbounds %BulletManager, ptr %input, i32 0, i32 2
  %readtmp3 = load ptr addrspace(5), ptr %8, align 8
  store ptr addrspace(5) %readtmp3, ptr %7, align 8
  %9 = getelementptr inbounds %BulletManager, ptr %result, i32 0, i32 0
  %readtmp4 = load ptr addrspace(5), ptr %9, align 8
  %10 = getelementptr inbounds %BulletManager, ptr %input, i32 0, i32 0
  %readtmp5 = load ptr addrspace(5), ptr %10, align 8
  %11 = getelementptr inbounds %BulletManager, ptr %input, i32 0, i32 1
  %readtmp6 = load i32, ptr %11, align 4
  %multmp7 = mul i32 %readtmp6, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Bullet], ptr addrspace(5) null, i32 1) to i32)
  %calltmp8 = call void @memcpy(ptr addrspace(5) %readtmp4, ptr addrspace(5) %readtmp5, i32 %multmp7)
  %readtmp9 = load %BulletManager, ptr %result, align 8
  ret %BulletManager %readtmp9
  %calltmp10 = call %BulletManager @BulletManager.copy_0(%BulletManager %extracted)
  store %BulletManager %calltmp10, ptr %1, align 8
  %readtmp11 = load %GameState, ptr %result, align 8
  ret %GameState %readtmp11
  %calltmp12 = call %GameState @GameState.copy_0(%GameState %readtmp)
  store %GameState %calltmp12, ptr %prevState, align 8
  %readtmp13 = load float, ptr %t, align 4
  %readtmp14 = load float, ptr %dt, align 4
}

define void @GameState.update_0(ptr addrspace(5) %0, float %1, float %2) {
entry:
  %dt = alloca float, align 4
  %t = alloca float, align 4
  %state = alloca ptr addrspace(5), align 8
  store float %2, ptr %dt, align 4
  store float %1, ptr %t, align 4
  store ptr addrspace(5) %0, ptr %state, align 8
  %readtmp = load ptr addrspace(5), ptr %state, align 8
  %3 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp, i32 0, i32 3
  %readtmp1 = load ptr addrspace(5), ptr %state, align 8
  %4 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp1, i32 0, i32 3
  %readtmp2 = load %Vec2, ptr addrspace(5) %4, align 4
  %calltmp = call %Vec2 @Vec2.mul_0(%Vec2 %readtmp2, float 0x3FECCCCCC0000000)
  store %Vec2 %calltmp, ptr addrspace(5) %3, align 4
  %readtmp3 = load ptr addrspace(5), ptr %state, align 8
  %5 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp3, i32 0, i32 3
  %readtmp4 = load ptr addrspace(5), ptr %state, align 8
  %6 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp4, i32 0, i32 3
  %readtmp5 = load %Vec2, ptr addrspace(5) %6, align 4
  %calltmp6 = call ptr addrspace(5) @Input.instance_0()
  %readtmp7 = load %Input, ptr addrspace(5) %calltmp6, align 4
  %extracted = extractvalue %Input %readtmp7, 0
  %readtmp8 = load float, ptr %dt, align 4
  %multmp = fmul float 2.000000e+03, %readtmp8
  %calltmp9 = call %Vec2 @Vec2.mul_0(%Vec2 %extracted, float %multmp)
  %calltmp10 = call %Vec2 @Vec2.add_0(%Vec2 %readtmp5, %Vec2 %calltmp9)
  store %Vec2 %calltmp10, ptr addrspace(5) %5, align 4
  %calltmp11 = call ptr addrspace(5) @Input.instance_0()
  %7 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp11, i32 0, i32 1
  %readtmp12 = load i1, ptr addrspace(5) %7, align 1
  %ifcond = icmp ne i1 %readtmp12, false
  br i1 %ifcond, label %ifbody, label %ifmerge

ifbody:                                           ; preds = %entry
  %readtmp13 = load ptr addrspace(5), ptr %state, align 8
  %8 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp13, i32 0, i32 4
  %readtmp14 = load ptr addrspace(5), ptr %state, align 8
  %9 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp14, i32 0, i32 1
  %10 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %9, i32 0, i32 1
  %readtmp15 = load %Vec2, ptr addrspace(5) %10, align 4
  %calltmp16 = call %Vec2 @Vec2.new_0(float 3.200000e+01, float 1.600000e+01)
  %calltmp17 = call %Vec2 @Vec2.add_0(%Vec2 %readtmp15, %Vec2 %calltmp16)

ifmerge:                                          ; preds = %entry, %entry
  %readtmp18 = load ptr addrspace(5), ptr %state, align 8
  %11 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp18, i32 0, i32 1
  %12 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %11, i32 0, i32 1
  %13 = getelementptr inbounds %Vec2, ptr addrspace(5) %12, i32 0, i32 1
  %readtmp19 = load ptr addrspace(5), ptr %state, align 8
  %14 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp19, i32 0, i32 1
  %15 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %14, i32 0, i32 1
  %16 = getelementptr inbounds %Vec2, ptr addrspace(5) %15, i32 0, i32 1
  %readtmp20 = load float, ptr addrspace(5) %16, align 4
  %readtmp21 = load float, ptr %dt, align 4
  %readtmp22 = load ptr addrspace(5), ptr %state, align 8
  %17 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp22, i32 0, i32 3
  %18 = getelementptr inbounds %Vec2, ptr addrspace(5) %17, i32 0, i32 1
  %readtmp23 = load float, ptr addrspace(5) %18, align 4
  %multmp24 = fmul float %readtmp21, %readtmp23
  %addtmp = fadd float %readtmp20, %multmp24
  store float %addtmp, ptr addrspace(5) %13, align 4
  %readtmp25 = load ptr addrspace(5), ptr %state, align 8
  %19 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp25, i32 0, i32 1
  %20 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %19, i32 0, i32 1
  %21 = getelementptr inbounds %Vec2, ptr addrspace(5) %20, i32 0, i32 0
  %readtmp26 = load ptr addrspace(5), ptr %state, align 8
  %22 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp26, i32 0, i32 1
  %23 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %22, i32 0, i32 1
  %24 = getelementptr inbounds %Vec2, ptr addrspace(5) %23, i32 0, i32 0
  %readtmp27 = load float, ptr addrspace(5) %24, align 4
  %readtmp28 = load float, ptr %dt, align 4
  %readtmp29 = load ptr addrspace(5), ptr %state, align 8
  %25 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp29, i32 0, i32 3
  %26 = getelementptr inbounds %Vec2, ptr addrspace(5) %25, i32 0, i32 0
  %readtmp30 = load float, ptr addrspace(5) %26, align 4
  %multmp31 = fmul float %readtmp28, %readtmp30
  %addtmp32 = fadd float %readtmp27, %multmp31
  store float %addtmp32, ptr addrspace(5) %21, align 4
  %readtmp33 = load ptr addrspace(5), ptr %state, align 8
  %27 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp33, i32 0, i32 4
  %readtmp34 = load float, ptr %t, align 4
  %readtmp35 = load float, ptr %dt, align 4
}

define void @BulletManager.spawn_0(ptr addrspace(5) %0, i1 %1, %Vec2 %2) {
entry:
  %self = alloca ptr addrspace(5), align 8
  %idx = alloca i32, align 4
  %pos = alloca %Vec2, align 8
  store %Vec2 %2, ptr %pos, align 4
  store ptr addrspace(5) %0, ptr %self, align 8
  %readtmp = load ptr addrspace(5), ptr %self, align 8
  %3 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp, i32 0, i32 1
  %readtmp1 = load i32, ptr addrspace(5) %3, align 4
  store i32 %readtmp1, ptr %idx, align 4
  %readtmp2 = load ptr addrspace(5), ptr %self, align 8
  %4 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp2, i32 0, i32 0
  %readtmp3 = load ptr addrspace(5), ptr %self, align 8
  %5 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp3, i32 0, i32 0
  %readtmp4 = load ptr addrspace(5), ptr addrspace(5) %5, align 8
  %readtmp5 = load i32, ptr %idx, align 4
  %addtmp = add i32 %readtmp5, 1
  %multmp = mul i32 %addtmp, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Bullet], ptr addrspace(5) null, i32 1) to i32)
  %calltmp = call ptr addrspace(5) @realloc(ptr addrspace(5) %readtmp4, i32 %multmp)
  store ptr addrspace(5) %calltmp, ptr addrspace(5) %4, align 8
  %readtmp6 = load ptr addrspace(5), ptr %self, align 8
  %6 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp6, i32 0, i32 1
  %readtmp7 = load i32, ptr %idx, align 4
  %addtmp8 = add i32 %readtmp7, 1
  store i32 %addtmp8, ptr addrspace(5) %6, align 4
  %added = alloca ptr addrspace(5), align 8
  %readtmp9 = load ptr addrspace(5), ptr %self, align 8
  %7 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp9, i32 0, i32 0
  %readtmp10 = load ptr addrspace(5), ptr addrspace(5) %7, align 8
  %readtmp11 = load i32, ptr %idx, align 4
  %multmp12 = mul i32 %readtmp11, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Bullet], ptr addrspace(5) null, i32 1) to i32)
}

define ptr addrspace(5) @mem.add_2(ptr addrspace(5) %0, i64 %1) {
entry:
  %addtmp = add i64 %1, ptr addrspace(5) %0
  ret i64 %addtmp
  %calltmp = call ptr addrspace(5) @mem.add_2(ptr addrspace(5) %readtmp10, i32 %multmp12)
  store ptr addrspace(5) %calltmp, ptr %added, align 8
  %readtmp = load ptr addrspace(5), ptr %added, align 8
  %2 = getelementptr inbounds %Bullet, ptr addrspace(5) %readtmp, i32 0, i32 2
  store i1 %1, ptr addrspace(5) %2, align 1
  %readtmp1 = load ptr addrspace(5), ptr %added, align 8
  %3 = getelementptr inbounds %Bullet, ptr addrspace(5) %readtmp1, i32 0, i32 0
  %4 = getelementptr inbounds %Sprite, ptr addrspace(5) %3, i32 0, i32 0
  %5 = getelementptr inbounds %Vec2, ptr addrspace(5) %4, i32 0, i32 0
  store float 1.600000e+01, ptr addrspace(5) %5, align 4
  %readtmp2 = load ptr addrspace(5), ptr %added, align 8
  %6 = getelementptr inbounds %Bullet, ptr addrspace(5) %readtmp2, i32 0, i32 0
  %7 = getelementptr inbounds %Sprite, ptr addrspace(5) %6, i32 0, i32 0
  %8 = getelementptr inbounds %Vec2, ptr addrspace(5) %7, i32 0, i32 1
  store float 1.600000e+01, ptr addrspace(5) %8, align 4
  %readtmp3 = load ptr addrspace(5), ptr %added, align 8
  %9 = getelementptr inbounds %Bullet, ptr addrspace(5) %readtmp3, i32 0, i32 0
  %10 = getelementptr inbounds %Sprite, ptr addrspace(5) %9, i32 0, i32 1
  %11 = getelementptr inbounds %Vec2, ptr addrspace(5) %10, i32 0, i32 0
  %12 = getelementptr inbounds %Vec2, ptr %pos, i32 0, i32 0
  %readtmp4 = load float, ptr %12, align 4
  %subtmp = fsub float %readtmp4, 8.000000e+00
  store float %subtmp, ptr addrspace(5) %11, align 4
  %readtmp5 = load ptr addrspace(5), ptr %added, align 8
  %13 = getelementptr inbounds %Bullet, ptr addrspace(5) %readtmp5, i32 0, i32 0
  %14 = getelementptr inbounds %Sprite, ptr addrspace(5) %13, i32 0, i32 1
  %15 = getelementptr inbounds %Vec2, ptr addrspace(5) %14, i32 0, i32 1
  %16 = getelementptr inbounds %Vec2, ptr %pos, i32 0, i32 1
  %readtmp6 = load float, ptr %16, align 4
  %subtmp7 = fsub float %readtmp6, 8.000000e+00
  store float %subtmp7, ptr addrspace(5) %15, align 4
  %readtmp8 = load ptr addrspace(5), ptr %added, align 8
  %17 = getelementptr inbounds %Bullet, ptr addrspace(5) %readtmp8, i32 0, i32 3
  %18 = getelementptr inbounds %Vec2, ptr addrspace(5) %17, i32 0, i32 0
  store float 0.000000e+00, ptr addrspace(5) %18, align 4
  %readtmp9 = load ptr addrspace(5), ptr %added, align 8
  %19 = getelementptr inbounds %Bullet, ptr addrspace(5) %readtmp9, i32 0, i32 3
  %20 = getelementptr inbounds %Vec2, ptr addrspace(5) %19, i32 0, i32 1
  store float -5.000000e+02, ptr addrspace(5) %20, align 4
  ret void
  %calltmp10 = call void @BulletManager.spawn_0(ptr addrspace(5) %8, i1 true, %Vec2 %calltmp17)
  br label %ifmerge
}

define void @BulletManager.update_0(ptr addrspace(5) %0, float %1, float %2) {
entry:
  %self = alloca ptr addrspace(5), align 8
  %dt = alloca float, align 4
  %t = alloca float, align 4
  store float %2, ptr %dt, align 4
  store float %1, ptr %t, align 4
  store ptr addrspace(5) %0, ptr %self, align 8
  %idx = alloca i32, align 4
  store i32 0, ptr %idx, align 4
  %readtmp = load i32, ptr %idx, align 4
  %readtmp1 = load ptr addrspace(5), ptr %self, align 8
  %3 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp1, i32 0, i32 1
  %readtmp2 = load i32, ptr addrspace(5) %3, align 4
  %lttmp = icmp ult i32 %readtmp, %readtmp2
  %ifcond = icmp ne i1 %lttmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

ifbody:                                           ; preds = %entry
  br label %dobody

ifmerge:                                          ; preds = %domerge, %entry
  ret void
  %calltmp8 = call void @BulletManager.update_0(ptr addrspace(5) %27, float %readtmp34, float %readtmp35)
  %readtmp9 = load ptr addrspace(5), ptr %state, align 8
  %4 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp9, i32 0, i32 5

dobody:                                           ; preds = %entry, %ifbody
  %readtmp3 = load ptr addrspace(5), ptr %self, align 8
  %5 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp3, i32 0, i32 0
  %readtmp4 = load ptr addrspace(5), ptr addrspace(5) %5, align 8
  %readtmp5 = load i32, ptr %idx, align 4
  %multmp = mul i32 %readtmp5, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Bullet], ptr addrspace(5) null, i32 1) to i32)
  %calltmp = call ptr addrspace(5) @mem.add_2(ptr addrspace(5) %readtmp4, i32 %multmp)
  %readtmp6 = load float, ptr %t, align 4
  %readtmp7 = load float, ptr %dt, align 4

domerge:                                          ; preds = %entry
  br label %ifmerge
}

define void @Bullet.update_0(ptr addrspace(5) %0, float %1, float %2) {
entry:
  %dt = alloca float, align 4
  %t = alloca float, align 4
  %self = alloca ptr addrspace(5), align 8
  store float %2, ptr %dt, align 4
  store float %1, ptr %t, align 4
  store ptr addrspace(5) %0, ptr %self, align 8
  %readtmp = load ptr addrspace(5), ptr %self, align 8
  %3 = getelementptr inbounds %Bullet, ptr addrspace(5) %readtmp, i32 0, i32 0
  %4 = getelementptr inbounds %Sprite, ptr addrspace(5) %3, i32 0, i32 1
  %readtmp1 = load %Vec2, ptr addrspace(5) %4, align 4
  %readtmp2 = load ptr addrspace(5), ptr %self, align 8
  %5 = getelementptr inbounds %Bullet, ptr addrspace(5) %readtmp2, i32 0, i32 3
  %readtmp3 = load %Vec2, ptr addrspace(5) %5, align 4
  %readtmp4 = load float, ptr %dt, align 4
  %calltmp = call %Vec2 @Vec2.mul_0(%Vec2 %readtmp3, float %readtmp4)
  %calltmp5 = call %Vec2 @Vec2.add_0(%Vec2 %readtmp1, %Vec2 %calltmp)
  store %Vec2 %calltmp5, ptr addrspace(5) %4, align 4
  ret void
  %calltmp6 = call void @Bullet.update_0(ptr addrspace(5) %calltmp, float %readtmp6, float %readtmp7)
  %readtmp7 = load i32, ptr %idx, align 4
  %addtmp = add i32 %readtmp7, 1
  store i32 %addtmp, ptr %idx, align 4
  %readtmp8 = load i32, ptr %idx, align 4
  %readtmp9 = load ptr addrspace(5), ptr %self, align 8
  %6 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp9, i32 0, i32 1
  %readtmp10 = load i32, ptr addrspace(5) %6, align 4
  %lttmp = icmp ult i32 %readtmp8, %readtmp10
  %docond = icmp ne i1 %lttmp, false
  br i1 %docond, label %dobody, label %domerge
}

define void @Stars.update_0(ptr addrspace(5) %0) {
entry:
  %self = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %self, align 8
  %idx = alloca i32, align 4
  store i32 0, ptr %idx, align 4
  br label %dobody

dobody:                                           ; preds = %ifmerge, %entry
  %current = alloca ptr addrspace(5), align 8
  %readtmp = load ptr addrspace(5), ptr %self, align 8
  %1 = getelementptr inbounds %Stars, ptr addrspace(5) %readtmp, i32 0, i32 1
  %readtmp1 = load i32, ptr %idx, align 4
  %multmp = mul i32 %readtmp1, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Star], ptr addrspace(5) null, i32 1) to i32)
  %calltmp = call ptr addrspace(5) @mem.add_0(ptr addrspace(5) %1, i32 %multmp)
  store ptr addrspace(5) %calltmp, ptr %current, align 8
  %readtmp2 = load ptr addrspace(5), ptr %current, align 8
  %2 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp2, i32 0, i32 2
  %3 = getelementptr inbounds %Vec2, ptr addrspace(5) %2, i32 0, i32 1
  %readtmp3 = load float, ptr addrspace(5) %3, align 4
  %readtmp4 = load ptr addrspace(5), ptr %current, align 8
  %4 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp4, i32 0, i32 0
  %readtmp5 = load float, ptr addrspace(5) %4, align 4
  %multmp6 = fmul float %readtmp5, 2.000000e+00
  %addtmp = fadd float %readtmp3, %multmp6
  store float %addtmp, ptr addrspace(5) %3, align 4
  %readtmp7 = load ptr addrspace(5), ptr %current, align 8
  %5 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp7, i32 0, i32 2
  %6 = getelementptr inbounds %Vec2, ptr addrspace(5) %5, i32 0, i32 1
  %readtmp8 = load float, ptr addrspace(5) %6, align 4
  %gttmp = fcmp uge float %readtmp8, 4.800000e+02
  %ifcond = icmp ne i1 %gttmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

domerge:                                          ; preds = %ifmerge
  ret void
  %calltmp23 = call void @Stars.update_0(ptr addrspace(5) %4)
  ret void
  %calltmp24 = call void @GameState.update_0(ptr %currState, float %readtmp13, float %readtmp14)
  %readtmp25 = load float, ptr %t, align 4
  %readtmp26 = load float, ptr %dt, align 4
  %addtmp27 = fadd float %readtmp25, %readtmp26
  store float %addtmp27, ptr %t, align 4
  %readtmp28 = load float, ptr %accumulator, align 4
  %readtmp29 = load float, ptr %dt, align 4
  %subtmp = fsub float %readtmp28, %readtmp29
  store float %subtmp, ptr %accumulator, align 4
  %readtmp30 = load float, ptr %accumulator, align 4
  %readtmp31 = load float, ptr %dt, align 4
  %lttmp32 = fcmp ule float %readtmp30, %readtmp31
  %nottmp = xor i1 %lttmp32, true
  %docond33 = icmp ne i1 %nottmp, false
  br i1 %docond33, label %dobody11, label %domerge12

ifbody:                                           ; preds = %dobody
  %readtmp9 = load ptr addrspace(5), ptr %current, align 8
  %7 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp9, i32 0, i32 2
  %8 = getelementptr inbounds %Vec2, ptr addrspace(5) %7, i32 0, i32 1
  store float -1.000000e+01, ptr addrspace(5) %8, align 4
  %readtmp10 = load ptr addrspace(5), ptr %current, align 8
  %9 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp10, i32 0, i32 2
  %10 = getelementptr inbounds %Vec2, ptr addrspace(5) %9, i32 0, i32 0
  %calltmp11 = call float @randf()
  %multmp12 = fmul float %calltmp11, 6.400000e+02
  store float %multmp12, ptr addrspace(5) %10, align 4
  %readtmp13 = load ptr addrspace(5), ptr %current, align 8
  %11 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp13, i32 0, i32 0
  %calltmp14 = call float @randf()
  %multmp15 = fmul float %calltmp14, 1.000000e+01
  %addtmp16 = fadd float %multmp15, 3.000000e+00
  store float %addtmp16, ptr addrspace(5) %11, align 4
  %readtmp17 = load ptr addrspace(5), ptr %current, align 8
  %12 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp17, i32 0, i32 1
  %readtmp18 = load ptr addrspace(5), ptr %current, align 8
  %13 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp18, i32 0, i32 1
  %readtmp19 = load i1, ptr addrspace(5) %13, align 1
  %neqtmp = icmp eq i1 false, %readtmp19
  store i1 %neqtmp, ptr addrspace(5) %12, align 1
  br label %ifmerge

ifmerge:                                          ; preds = %ifbody, %dobody
  %readtmp20 = load i32, ptr %idx, align 4
  %addtmp21 = add i32 %readtmp20, 1
  store i32 %addtmp21, ptr %idx, align 4
  %readtmp22 = load i32, ptr %idx, align 4
  %lttmp = icmp ult i32 %readtmp22, 100
  %docond = icmp ne i1 %lttmp, false
  br i1 %docond, label %dobody, label %domerge
}

define void @GameState.lerp_0(ptr addrspace(5) %0, %GameState %1, %GameState %2, float %3) {
entry:
  %result = alloca %GameState, align 8
  %a = alloca %GameState, align 8
  %b = alloca %GameState, align 8
  %pc = alloca float, align 4
  store float %3, ptr %pc, align 4
  store %GameState %2, ptr %a, align 8
  store %GameState %1, ptr %b, align 8
  store %GameState %1, ptr %result, align 8
  %4 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 1
  %readtmp = load %GameState, ptr %a, align 8
  %extracted = extractvalue %GameState %readtmp, 1
  %readtmp1 = load %GameState, ptr %b, align 8
  %extracted2 = extractvalue %GameState %readtmp1, 1
  %readtmp3 = load float, ptr %pc, align 4
}

define void @MultiSprite.lerp_0(ptr addrspace(5) %0, %MultiSprite %1, %MultiSprite %2, float %3) {
entry:
  %result = alloca %MultiSprite, align 8
  %a = alloca %MultiSprite, align 8
  %b = alloca %MultiSprite, align 8
  %pc = alloca float, align 4
  store float %3, ptr %pc, align 4
  store %MultiSprite %2, ptr %a, align 4
  store %MultiSprite %1, ptr %b, align 4
  store %MultiSprite %1, ptr %result, align 4
  %4 = getelementptr inbounds %MultiSprite, ptr %result, i32 0, i32 1
  %5 = getelementptr inbounds %MultiSprite, ptr %a, i32 0, i32 1
  %readtmp = load %Vec2, ptr %5, align 4
  %6 = getelementptr inbounds %MultiSprite, ptr %b, i32 0, i32 1
  %readtmp1 = load %Vec2, ptr %6, align 4
  %readtmp2 = load float, ptr %pc, align 4
}

define %Vec2 @Vec2.lerp_0(%Vec2 %0, %Vec2 %1, float %2) {
entry:
  %pc = alloca float, align 4
  store float %2, ptr %pc, align 4
  %readtmp = load float, ptr %pc, align 4
  %calltmp = call %Vec2 @Vec2.mul_0(%Vec2 %1, float %readtmp)
  %readtmp1 = load float, ptr %pc, align 4
  %subtmp = fsub float 1.000000e+00, %readtmp1
  %calltmp2 = call %Vec2 @Vec2.mul_0(%Vec2 %0, float %subtmp)
  %calltmp3 = call %Vec2 @Vec2.add_0(%Vec2 %calltmp, %Vec2 %calltmp2)
  ret %Vec2 %calltmp3
  %calltmp4 = call %Vec2 @Vec2.lerp_0(%Vec2 %readtmp, %Vec2 %readtmp1, float %readtmp2)
  store %Vec2 %calltmp4, ptr %4, align 4
  %3 = getelementptr inbounds %MultiSprite, ptr %result, i32 0, i32 0
  %4 = getelementptr inbounds %MultiSprite, ptr %a, i32 0, i32 0
  %readtmp5 = load %Vec2, ptr %4, align 4
  %5 = getelementptr inbounds %MultiSprite, ptr %b, i32 0, i32 0
  %readtmp6 = load %Vec2, ptr %5, align 4
  %readtmp7 = load float, ptr %pc, align 4
  %calltmp8 = call %Vec2 @Vec2.lerp_0(%Vec2 %readtmp5, %Vec2 %readtmp6, float %readtmp7)
  store %Vec2 %calltmp8, ptr %3, align 4
  %readtmp9 = load %MultiSprite, ptr %result, align 4
  store %MultiSprite %readtmp9, ptr addrspace(5) %0, align 4
  ret void
  %calltmp10 = call void @MultiSprite.lerp_0(ptr %4, %MultiSprite %extracted, %MultiSprite %extracted2, float %readtmp3)
  %6 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 4
  %readtmp11 = load %GameState, ptr %a, align 8
  %extracted = extractvalue %GameState %readtmp11, 4
  %readtmp12 = load %GameState, ptr %b, align 8
  %extracted13 = extractvalue %GameState %readtmp12, 4
  %readtmp14 = load float, ptr %pc, align 4
}

define void @BulletManager.lerp_0(ptr addrspace(5) %0, %BulletManager %1, %BulletManager %2, float %3) {
entry:
  %result = alloca %BulletManager, align 8
  %a = alloca %BulletManager, align 8
  %b = alloca %BulletManager, align 8
  %pc = alloca float, align 4
  store float %3, ptr %pc, align 4
  store %BulletManager %2, ptr %a, align 8
  store %BulletManager %1, ptr %b, align 8
  %calltmp = call %BulletManager @BulletManager.copy_0(%BulletManager %1)
  store %BulletManager %calltmp, ptr %result, align 8
  %idx = alloca i32, align 4
  store i32 0, ptr %idx, align 4
  %readtmp = load i32, ptr %idx, align 4
  %4 = getelementptr inbounds %BulletManager, ptr %a, i32 0, i32 1
  %readtmp1 = load i32, ptr %4, align 4
  %lttmp = icmp ult i32 %readtmp, %readtmp1
  %ifcond = icmp ne i1 %lttmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

ifbody:                                           ; preds = %entry
  br label %dobody

ifmerge:                                          ; preds = %domerge, %entry
  %readtmp16 = load %BulletManager, ptr %result, align 8
  store %BulletManager %readtmp16, ptr addrspace(5) %0, align 8
  ret void
  %calltmp17 = call void @BulletManager.lerp_0(ptr %6, %BulletManager %extracted, %BulletManager %extracted13, float %readtmp14)
  %5 = getelementptr inbounds %GameState, ptr %result, i32 0, i32 5
  %readtmp18 = load %GameState, ptr %a, align 8
  %extracted = extractvalue %GameState %readtmp18, 5
  %readtmp19 = load %GameState, ptr %b, align 8
  %extracted20 = extractvalue %GameState %readtmp19, 5
  %readtmp21 = load float, ptr %pc, align 4

dobody:                                           ; preds = %entry, %ifbody
  %6 = getelementptr inbounds %BulletManager, ptr %result, i32 0, i32 0
  %readtmp2 = load ptr addrspace(5), ptr %6, align 8
  %readtmp3 = load i32, ptr %idx, align 4
  %multmp = mul i32 %readtmp3, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Bullet], ptr addrspace(5) null, i32 1) to i32)
  %calltmp4 = call ptr addrspace(5) @mem.add_2(ptr addrspace(5) %readtmp2, i32 %multmp)
  %7 = getelementptr inbounds %BulletManager, ptr %a, i32 0, i32 0
  %readtmp5 = load ptr addrspace(5), ptr %7, align 8
  %readtmp6 = load i32, ptr %idx, align 4
  %multmp7 = mul i32 %readtmp6, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Bullet], ptr addrspace(5) null, i32 1) to i32)
  %calltmp8 = call ptr addrspace(5) @mem.add_2(ptr addrspace(5) %readtmp5, i32 %multmp7)
  %readtmp9 = load %Bullet, ptr addrspace(5) %calltmp8, align 8
  %8 = getelementptr inbounds %BulletManager, ptr %b, i32 0, i32 0
  %readtmp10 = load ptr addrspace(5), ptr %8, align 8
  %readtmp11 = load i32, ptr %idx, align 4
  %multmp12 = mul i32 %readtmp11, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Bullet], ptr addrspace(5) null, i32 1) to i32)
  %calltmp13 = call ptr addrspace(5) @mem.add_2(ptr addrspace(5) %readtmp10, i32 %multmp12)
  %readtmp14 = load %Bullet, ptr addrspace(5) %calltmp13, align 8
  %readtmp15 = load float, ptr %pc, align 4

domerge:                                          ; preds = %entry
  br label %ifmerge
}

define void @Bullet.lerp_0(ptr addrspace(5) %0, %Bullet %1, %Bullet %2, float %3) {
entry:
  %result = alloca %Bullet, align 8
  %a = alloca %Bullet, align 8
  %b = alloca %Bullet, align 8
  %pc = alloca float, align 4
  store float %3, ptr %pc, align 4
  store %Bullet %2, ptr %a, align 8
  store %Bullet %1, ptr %b, align 8
  store %Bullet %1, ptr %result, align 8
  %4 = getelementptr inbounds %Bullet, ptr %result, i32 0, i32 0
  %readtmp = load %Bullet, ptr %a, align 8
  %extracted = extractvalue %Bullet %readtmp, 0
  %readtmp1 = load %Bullet, ptr %b, align 8
  %extracted2 = extractvalue %Bullet %readtmp1, 0
  %readtmp3 = load float, ptr %pc, align 4
}

define void @Sprite.lerp_0(ptr addrspace(5) %0, %Sprite %1, %Sprite %2, float %3) {
entry:
  %result = alloca %Sprite, align 8
  %a = alloca %Sprite, align 8
  %b = alloca %Sprite, align 8
  %pc = alloca float, align 4
  store float %3, ptr %pc, align 4
  store %Sprite %2, ptr %a, align 4
  store %Sprite %1, ptr %b, align 4
  store %Sprite %1, ptr %result, align 4
  %4 = getelementptr inbounds %Sprite, ptr %result, i32 0, i32 1
  %5 = getelementptr inbounds %Sprite, ptr %a, i32 0, i32 1
  %readtmp = load %Vec2, ptr %5, align 4
  %6 = getelementptr inbounds %Sprite, ptr %b, i32 0, i32 1
  %readtmp1 = load %Vec2, ptr %6, align 4
  %readtmp2 = load float, ptr %pc, align 4
  %calltmp = call %Vec2 @Vec2.lerp_0(%Vec2 %readtmp, %Vec2 %readtmp1, float %readtmp2)
  store %Vec2 %calltmp, ptr %4, align 4
  %7 = getelementptr inbounds %Sprite, ptr %result, i32 0, i32 0
  %8 = getelementptr inbounds %Sprite, ptr %a, i32 0, i32 0
  %readtmp3 = load %Vec2, ptr %8, align 4
  %9 = getelementptr inbounds %Sprite, ptr %b, i32 0, i32 0
  %readtmp4 = load %Vec2, ptr %9, align 4
  %readtmp5 = load float, ptr %pc, align 4
  %calltmp6 = call %Vec2 @Vec2.lerp_0(%Vec2 %readtmp3, %Vec2 %readtmp4, float %readtmp5)
  store %Vec2 %calltmp6, ptr %7, align 4
  %readtmp7 = load %Sprite, ptr %result, align 4
  store %Sprite %readtmp7, ptr addrspace(5) %0, align 4
  ret void
  %calltmp8 = call void @Sprite.lerp_0(ptr %4, %Sprite %extracted, %Sprite %extracted2, float %readtmp3)
  %readtmp9 = load %Bullet, ptr %result, align 8
  store %Bullet %readtmp9, ptr addrspace(5) %0, align 8
  ret void
  %calltmp10 = call void @Bullet.lerp_0(ptr addrspace(5) %calltmp4, %Bullet %readtmp9, %Bullet %readtmp14, float %readtmp15)
  %readtmp11 = load i32, ptr %idx, align 4
  %addtmp = add i32 %readtmp11, 1
  store i32 %addtmp, ptr %idx, align 4
  %readtmp12 = load i32, ptr %idx, align 4
  %10 = getelementptr inbounds %BulletManager, ptr %a, i32 0, i32 1
  %readtmp13 = load i32, ptr %10, align 4
  %lttmp = icmp ult i32 %readtmp12, %readtmp13
  %docond = icmp ne i1 %lttmp, false
  br i1 %docond, label %dobody, label %domerge
}

define void @Stars.lerp_0(ptr addrspace(5) %0, %Stars %1, %Stars %2, float %3) {
entry:
  %result = alloca %Stars, align 8
  %a = alloca %Stars, align 8
  %b = alloca %Stars, align 8
  %pc = alloca float, align 4
  store float %3, ptr %pc, align 4
  store %Stars %2, ptr %a, align 8
  store %Stars %1, ptr %b, align 8
  store %Stars %1, ptr %result, align 8
  %idx = alloca i32, align 4
  store i32 0, ptr %idx, align 4
  br label %dobody

dobody:                                           ; preds = %ifmerge, %entry
  %currenta = alloca ptr addrspace(5), align 8
  %4 = getelementptr inbounds %Stars, ptr %a, i32 0, i32 1
  %readtmp = load i32, ptr %idx, align 4
  %multmp = mul i32 %readtmp, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Star], ptr addrspace(5) null, i32 1) to i32)
  %calltmp = call ptr addrspace(5) @mem.add_0(ptr %4, i32 %multmp)
  store ptr addrspace(5) %calltmp, ptr %currenta, align 8
  %currentb = alloca ptr addrspace(5), align 8
  %5 = getelementptr inbounds %Stars, ptr %b, i32 0, i32 1
  %readtmp1 = load i32, ptr %idx, align 4
  %multmp2 = mul i32 %readtmp1, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Star], ptr addrspace(5) null, i32 1) to i32)
  %calltmp3 = call ptr addrspace(5) @mem.add_0(ptr %5, i32 %multmp2)
  store ptr addrspace(5) %calltmp3, ptr %currentb, align 8
  %curres = alloca ptr addrspace(5), align 8
  %6 = getelementptr inbounds %Stars, ptr %result, i32 0, i32 1
  %readtmp4 = load i32, ptr %idx, align 4
  %multmp5 = mul i32 %readtmp4, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Star], ptr addrspace(5) null, i32 1) to i32)
  %calltmp6 = call ptr addrspace(5) @mem.add_0(ptr %6, i32 %multmp5)
  store ptr addrspace(5) %calltmp6, ptr %curres, align 8
  %readtmp7 = load ptr addrspace(5), ptr %currenta, align 8
  %7 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp7, i32 0, i32 1
  %readtmp8 = load i1, ptr addrspace(5) %7, align 1
  %readtmp9 = load ptr addrspace(5), ptr %currentb, align 8
  %8 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp9, i32 0, i32 1
  %readtmp10 = load i1, ptr addrspace(5) %8, align 1
  %neqtmp = icmp eq i1 %readtmp10, %readtmp8
  %ifcond = icmp ne i1 %neqtmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

domerge:                                          ; preds = %ifmerge
  %readtmp20 = load %Stars, ptr %result, align 8
  store %Stars %readtmp20, ptr addrspace(5) %0, align 8
  ret void
  %calltmp21 = call void @Stars.lerp_0(ptr %5, %Stars %extracted, %Stars %extracted20, float %readtmp21)
  %readtmp22 = load %GameState, ptr %result, align 8
  store %GameState %readtmp22, ptr addrspace(5) %0, align 8
  ret void
  %calltmp23 = call void @GameState.lerp_0(ptr %state, %GameState %readtmp16, %GameState %readtmp17, float %readtmp18)

ifbody:                                           ; preds = %dobody
  %readtmp11 = load ptr addrspace(5), ptr %curres, align 8
  %9 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp11, i32 0, i32 2
  %readtmp12 = load ptr addrspace(5), ptr %currenta, align 8
  %10 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp12, i32 0, i32 2
  %readtmp13 = load %Vec2, ptr addrspace(5) %10, align 4
  %readtmp14 = load ptr addrspace(5), ptr %currentb, align 8
  %11 = getelementptr inbounds %Star, ptr addrspace(5) %readtmp14, i32 0, i32 2
  %readtmp15 = load %Vec2, ptr addrspace(5) %11, align 4
  %readtmp16 = load float, ptr %pc, align 4
  %calltmp17 = call %Vec2 @Vec2.lerp_0(%Vec2 %readtmp13, %Vec2 %readtmp15, float %readtmp16)
  store %Vec2 %calltmp17, ptr addrspace(5) %9, align 4
  br label %ifmerge

ifmerge:                                          ; preds = %ifbody, %dobody
  %readtmp18 = load i32, ptr %idx, align 4
  %addtmp = add i32 %readtmp18, 1
  store i32 %addtmp, ptr %idx, align 4
  %readtmp19 = load i32, ptr %idx, align 4
  %lttmp = icmp ult i32 %readtmp19, 100
  %docond = icmp ne i1 %lttmp, false
  br i1 %docond, label %dobody, label %domerge
}

define void @GameState.draw_0(ptr addrspace(5) %0, ptr addrspace(5) %1) {
entry:
  %sb = alloca ptr addrspace(5), align 8
  %state = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %1, ptr %sb, align 8
  store ptr addrspace(5) %0, ptr %state, align 8
  %readtmp = load ptr addrspace(5), ptr %state, align 8
  %2 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp, i32 0, i32 1
  %3 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %2, i32 0, i32 3
  %4 = getelementptr inbounds %Vec2, ptr addrspace(5) %3, i32 0, i32 0
  store float 1.000000e+00, ptr addrspace(5) %4, align 4
  %readtmp1 = load ptr addrspace(5), ptr %state, align 8
  %5 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp1, i32 0, i32 1
  %6 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %5, i32 0, i32 3
  %7 = getelementptr inbounds %Vec2, ptr addrspace(5) %6, i32 0, i32 1
  store float 1.000000e+00, ptr addrspace(5) %7, align 4
  %calltmp = call ptr addrspace(5) @Input.instance_0()
  %8 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp, i32 0, i32 0
  %9 = getelementptr inbounds %Vec2, ptr addrspace(5) %8, i32 0, i32 0
  %readtmp2 = load float, ptr addrspace(5) %9, align 4
  %lttmp = fcmp ule float %readtmp2, 0xBFB99999A0000000
  %ifcond = icmp ne i1 %lttmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

ifbody:                                           ; preds = %entry
  %readtmp3 = load ptr addrspace(5), ptr %state, align 8
  %10 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp3, i32 0, i32 1
  %11 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %10, i32 0, i32 3
  %12 = getelementptr inbounds %Vec2, ptr addrspace(5) %11, i32 0, i32 0
  store float 0.000000e+00, ptr addrspace(5) %12, align 4
  br label %ifmerge

ifmerge:                                          ; preds = %ifbody, %entry
  %calltmp4 = call ptr addrspace(5) @Input.instance_0()
  %13 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp4, i32 0, i32 0
  %14 = getelementptr inbounds %Vec2, ptr addrspace(5) %13, i32 0, i32 0
  %readtmp5 = load float, ptr addrspace(5) %14, align 4
  %gttmp = fcmp uge float %readtmp5, 0x3FB99999A0000000
  %ifcond6 = icmp ne i1 %gttmp, false
  br i1 %ifcond6, label %ifbody7, label %ifmerge8

ifbody7:                                          ; preds = %ifmerge
  %readtmp9 = load ptr addrspace(5), ptr %state, align 8
  %15 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp9, i32 0, i32 1
  %16 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %15, i32 0, i32 3
  %17 = getelementptr inbounds %Vec2, ptr addrspace(5) %16, i32 0, i32 0
  store float 2.000000e+00, ptr addrspace(5) %17, align 4
  br label %ifmerge8

ifmerge8:                                         ; preds = %ifbody7, %ifmerge
  %calltmp10 = call ptr addrspace(5) @Input.instance_0()
  %18 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp10, i32 0, i32 0
  %19 = getelementptr inbounds %Vec2, ptr addrspace(5) %18, i32 0, i32 1
  %readtmp11 = load float, ptr addrspace(5) %19, align 4
  %lttmp12 = fcmp ule float %readtmp11, 0xBFB99999A0000000
  %ifcond13 = icmp ne i1 %lttmp12, false
  br i1 %ifcond13, label %ifbody14, label %ifmerge15

ifbody14:                                         ; preds = %ifmerge8
  %readtmp16 = load ptr addrspace(5), ptr %state, align 8
  %20 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp16, i32 0, i32 1
  %21 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %20, i32 0, i32 3
  %22 = getelementptr inbounds %Vec2, ptr addrspace(5) %21, i32 0, i32 1
  store float 2.000000e+00, ptr addrspace(5) %22, align 4
  br label %ifmerge15

ifmerge15:                                        ; preds = %ifbody14, %ifmerge8
  %calltmp17 = call ptr addrspace(5) @Input.instance_0()
  %23 = getelementptr inbounds %Input, ptr addrspace(5) %calltmp17, i32 0, i32 0
  %24 = getelementptr inbounds %Vec2, ptr addrspace(5) %23, i32 0, i32 1
  %readtmp18 = load float, ptr addrspace(5) %24, align 4
  %gttmp19 = fcmp uge float %readtmp18, 0x3FB99999A0000000
  %ifcond20 = icmp ne i1 %gttmp19, false
  br i1 %ifcond20, label %ifbody21, label %ifmerge22

ifbody21:                                         ; preds = %ifmerge15
  %readtmp23 = load ptr addrspace(5), ptr %state, align 8
  %25 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp23, i32 0, i32 1
  %26 = getelementptr inbounds %MultiSprite, ptr addrspace(5) %25, i32 0, i32 3
  %27 = getelementptr inbounds %Vec2, ptr addrspace(5) %26, i32 0, i32 1
  store float 0.000000e+00, ptr addrspace(5) %27, align 4
  br label %ifmerge22

ifmerge22:                                        ; preds = %ifbody21, %ifmerge15
  %readtmp24 = load ptr addrspace(5), ptr %state, align 8
  %28 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp24, i32 0, i32 4
  %readtmp25 = load ptr addrspace(5), ptr %sb, align 8
}

define void @BulletManager.draw_0(ptr addrspace(5) %0, ptr addrspace(5) %1) {
entry:
  %self = alloca ptr addrspace(5), align 8
  %sb = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %1, ptr %sb, align 8
  store ptr addrspace(5) %0, ptr %self, align 8
  %idx = alloca i32, align 4
  store i32 0, ptr %idx, align 4
  %readtmp = load i32, ptr %idx, align 4
  %readtmp1 = load ptr addrspace(5), ptr %self, align 8
  %2 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp1, i32 0, i32 1
  %readtmp2 = load i32, ptr addrspace(5) %2, align 4
  %lttmp = icmp ult i32 %readtmp, %readtmp2
  %ifcond = icmp ne i1 %lttmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

ifbody:                                           ; preds = %entry
  br label %dobody

ifmerge:                                          ; preds = %domerge, %entry
  ret void
  %calltmp12 = call void @BulletManager.draw_0(ptr addrspace(5) %28, ptr addrspace(5) %readtmp25)
  %readtmp13 = load ptr addrspace(5), ptr %state, align 8
  %3 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp13, i32 0, i32 0
  %elemtemp = getelementptr inbounds [1 x %Drawer], ptr addrspace(5) %3, i32 0, i32 0
  %4 = getelementptr inbounds %Drawer, ptr addrspace(5) %elemtemp, i32 0, i32 3
  %readtmp14 = load ptr addrspace(5), ptr %state, align 8
  %5 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp14, i32 0, i32 1
  store ptr addrspace(5) %5, ptr addrspace(5) %4, align 8
  %readtmp15 = load ptr addrspace(5), ptr %sb, align 8
  %readtmp16 = load ptr addrspace(5), ptr %state, align 8
  %6 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp16, i32 0, i32 0
  %elemtemp17 = getelementptr inbounds [1 x %Drawer], ptr addrspace(5) %6, i32 0, i32 0
  %readtmp18 = load %Drawer, ptr addrspace(5) %elemtemp17, align 8
  %calltmp19 = call void @SpriteBatch.draw_0(ptr addrspace(5) %readtmp15, %Drawer %readtmp18)
  %readtmp20 = load ptr addrspace(5), ptr %state, align 8
  %7 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp20, i32 0, i32 5
  %8 = getelementptr inbounds %Stars, ptr addrspace(5) %7, i32 0, i32 2
  %9 = getelementptr inbounds %Drawer, ptr addrspace(5) %8, i32 0, i32 3
  %readtmp21 = load ptr addrspace(5), ptr %state, align 8
  %10 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp21, i32 0, i32 5
  store ptr addrspace(5) %10, ptr addrspace(5) %9, align 8
  %readtmp22 = load ptr addrspace(5), ptr %sb, align 8
  %readtmp23 = load ptr addrspace(5), ptr %state, align 8
  %11 = getelementptr inbounds %GameState, ptr addrspace(5) %readtmp23, i32 0, i32 5
  %12 = getelementptr inbounds %Stars, ptr addrspace(5) %11, i32 0, i32 2
  %readtmp24 = load %Drawer, ptr addrspace(5) %12, align 8
  %calltmp25 = call void @SpriteBatch.draw_0(ptr addrspace(5) %readtmp22, %Drawer %readtmp24)
  ret void
  %calltmp26 = call void @GameState.draw_0(ptr %state, ptr %sb)
  %readtmp27 = load ptr addrspace(5), ptr %ctx, align 8

dobody:                                           ; preds = %entry, %ifbody
  %readtmp3 = load ptr addrspace(5), ptr %self, align 8
  %13 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp3, i32 0, i32 0
  %readtmp4 = load ptr addrspace(5), ptr addrspace(5) %13, align 8
  %readtmp5 = load i32, ptr %idx, align 4
  %multmp = mul i32 %readtmp5, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Bullet], ptr addrspace(5) null, i32 1) to i32)
  %calltmp = call ptr addrspace(5) @mem.add_2(ptr addrspace(5) %readtmp4, i32 %multmp)
  %readtmp6 = load %Bullet, ptr addrspace(5) %calltmp, align 8
  %readtmp7 = load ptr addrspace(5), ptr %sb, align 8
  %readtmp8 = load ptr addrspace(5), ptr %self, align 8
  %14 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp8, i32 0, i32 2
  %readtmp9 = load ptr addrspace(5), ptr addrspace(5) %14, align 8
  %readtmp10 = load ptr addrspace(5), ptr %self, align 8
  %15 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp10, i32 0, i32 3
  %readtmp11 = load ptr addrspace(5), ptr addrspace(5) %15, align 8

domerge:                                          ; preds = %entry
  br label %ifmerge
}

define void @Bullet.draw_0(%Bullet %0, ptr addrspace(5) %1, ptr addrspace(5) %2, ptr addrspace(5) %3) {
entry:
  %self = alloca %Bullet, align 8
  %sb = alloca ptr addrspace(5), align 8
  %tex = alloca ptr addrspace(5), align 8
  %shd = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %3, ptr %shd, align 8
  store ptr addrspace(5) %2, ptr %tex, align 8
  store ptr addrspace(5) %1, ptr %sb, align 8
  store %Bullet %0, ptr %self, align 8
  %4 = getelementptr inbounds %Bullet, ptr %self, i32 0, i32 1
  %5 = getelementptr inbounds %Drawer, ptr %4, i32 0, i32 3
  %6 = getelementptr inbounds %Bullet, ptr %self, i32 0, i32 0
  store ptr %6, ptr %5, align 8
  %7 = getelementptr inbounds %Bullet, ptr %self, i32 0, i32 1
  %8 = getelementptr inbounds %Drawer, ptr %7, i32 0, i32 2
  %readtmp = load ptr addrspace(5), ptr %shd, align 8
  store ptr addrspace(5) %readtmp, ptr %8, align 8
  %9 = getelementptr inbounds %Bullet, ptr %self, i32 0, i32 1
  %10 = getelementptr inbounds %Drawer, ptr %9, i32 0, i32 1
  %readtmp1 = load ptr addrspace(5), ptr %tex, align 8
  store ptr addrspace(5) %readtmp1, ptr %10, align 8
  %11 = getelementptr inbounds %Bullet, ptr %self, i32 0, i32 1
  %12 = getelementptr inbounds %Drawer, ptr %11, i32 0, i32 0
}

define ptr addrspace(5) @Sprite.getVerts_0(ptr addrspace(5) %0) {
entry:
  %self = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %self, align 8
  %v = alloca ptr addrspace(5), align 8
  %calltmp = call ptr addrspace(5) @malloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Verts], ptr addrspace(5) null, i32 1) to i32))
  store ptr addrspace(5) %calltmp, ptr %v, align 8
  %readtmp = load ptr addrspace(5), ptr %v, align 8
  %1 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp, i32 0, i32 0
  %calltmp1 = call ptr addrspace(5) @calloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Vert], ptr addrspace(5) null, i32 1) to i32), i64 6)
  store ptr addrspace(5) %calltmp1, ptr addrspace(5) %1, align 8
  %readtmp2 = load ptr addrspace(5), ptr %v, align 8
  %2 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp2, i32 0, i32 1
  store i32 6, ptr addrspace(5) %2, align 4
  %readtmp3 = load ptr addrspace(5), ptr %v, align 8
  %3 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp3, i32 0, i32 0
  %readtmp4 = load ptr addrspace(5), ptr addrspace(5) %3, align 8
  %elemtemp = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp4, i32 0, i32 0
  %4 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp, i32 0, i32 0
  %readtmp5 = load ptr addrspace(5), ptr %self, align 8
  %5 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp5, i32 0, i32 1
  %6 = getelementptr inbounds %Vec2, ptr addrspace(5) %5, i32 0, i32 0
  %readtmp6 = load float, ptr addrspace(5) %6, align 4
  store float %readtmp6, ptr addrspace(5) %4, align 4
  %readtmp7 = load ptr addrspace(5), ptr %v, align 8
  %7 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp7, i32 0, i32 0
  %readtmp8 = load ptr addrspace(5), ptr addrspace(5) %7, align 8
  %elemtemp9 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp8, i32 0, i32 0
  %8 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp9, i32 0, i32 1
  %readtmp10 = load ptr addrspace(5), ptr %self, align 8
  %9 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp10, i32 0, i32 1
  %10 = getelementptr inbounds %Vec2, ptr addrspace(5) %9, i32 0, i32 1
  %readtmp11 = load float, ptr addrspace(5) %10, align 4
  store float %readtmp11, ptr addrspace(5) %8, align 4
  %readtmp12 = load ptr addrspace(5), ptr %v, align 8
  %11 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp12, i32 0, i32 0
  %readtmp13 = load ptr addrspace(5), ptr addrspace(5) %11, align 8
  %elemtemp14 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp13, i32 0, i32 0
  %12 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp14, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %12, align 4
  %readtmp15 = load ptr addrspace(5), ptr %v, align 8
  %13 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp15, i32 0, i32 0
  %readtmp16 = load ptr addrspace(5), ptr addrspace(5) %13, align 8
  %elemtemp17 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp16, i32 0, i32 0
  %14 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp17, i32 0, i32 3
  store float 0.000000e+00, ptr addrspace(5) %14, align 4
  %readtmp18 = load ptr addrspace(5), ptr %v, align 8
  %15 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp18, i32 0, i32 0
  %readtmp19 = load ptr addrspace(5), ptr addrspace(5) %15, align 8
  %elemtemp20 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp19, i32 0, i32 0
  %16 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp20, i32 0, i32 4
  store float 0.000000e+00, ptr addrspace(5) %16, align 4
  %readtmp21 = load ptr addrspace(5), ptr %v, align 8
  %17 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp21, i32 0, i32 0
  %readtmp22 = load ptr addrspace(5), ptr addrspace(5) %17, align 8
  %elemtemp23 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp22, i32 0, i32 1
  %18 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp23, i32 0, i32 0
  %readtmp24 = load ptr addrspace(5), ptr %self, align 8
  %19 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp24, i32 0, i32 1
  %20 = getelementptr inbounds %Vec2, ptr addrspace(5) %19, i32 0, i32 0
  %readtmp25 = load float, ptr addrspace(5) %20, align 4
  %readtmp26 = load ptr addrspace(5), ptr %self, align 8
  %21 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp26, i32 0, i32 0
  %22 = getelementptr inbounds %Vec2, ptr addrspace(5) %21, i32 0, i32 0
  %readtmp27 = load float, ptr addrspace(5) %22, align 4
  %addtmp = fadd float %readtmp25, %readtmp27
  store float %addtmp, ptr addrspace(5) %18, align 4
  %readtmp28 = load ptr addrspace(5), ptr %v, align 8
  %23 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp28, i32 0, i32 0
  %readtmp29 = load ptr addrspace(5), ptr addrspace(5) %23, align 8
  %elemtemp30 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp29, i32 0, i32 1
  %24 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp30, i32 0, i32 1
  %readtmp31 = load ptr addrspace(5), ptr %self, align 8
  %25 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp31, i32 0, i32 1
  %26 = getelementptr inbounds %Vec2, ptr addrspace(5) %25, i32 0, i32 1
  %readtmp32 = load float, ptr addrspace(5) %26, align 4
  %readtmp33 = load ptr addrspace(5), ptr %self, align 8
  %27 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp33, i32 0, i32 0
  %28 = getelementptr inbounds %Vec2, ptr addrspace(5) %27, i32 0, i32 1
  %readtmp34 = load float, ptr addrspace(5) %28, align 4
  %addtmp35 = fadd float %readtmp32, %readtmp34
  store float %addtmp35, ptr addrspace(5) %24, align 4
  %readtmp36 = load ptr addrspace(5), ptr %v, align 8
  %29 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp36, i32 0, i32 0
  %readtmp37 = load ptr addrspace(5), ptr addrspace(5) %29, align 8
  %elemtemp38 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp37, i32 0, i32 1
  %30 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp38, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %30, align 4
  %readtmp39 = load ptr addrspace(5), ptr %v, align 8
  %31 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp39, i32 0, i32 0
  %readtmp40 = load ptr addrspace(5), ptr addrspace(5) %31, align 8
  %elemtemp41 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp40, i32 0, i32 1
  %32 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp41, i32 0, i32 3
  store float 1.000000e+00, ptr addrspace(5) %32, align 4
  %readtmp42 = load ptr addrspace(5), ptr %v, align 8
  %33 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp42, i32 0, i32 0
  %readtmp43 = load ptr addrspace(5), ptr addrspace(5) %33, align 8
  %elemtemp44 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp43, i32 0, i32 1
  %34 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp44, i32 0, i32 4
  store float 1.000000e+00, ptr addrspace(5) %34, align 4
  %readtmp45 = load ptr addrspace(5), ptr %v, align 8
  %35 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp45, i32 0, i32 0
  %readtmp46 = load ptr addrspace(5), ptr addrspace(5) %35, align 8
  %elemtemp47 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp46, i32 0, i32 2
  %36 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp47, i32 0, i32 0
  %readtmp48 = load ptr addrspace(5), ptr %self, align 8
  %37 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp48, i32 0, i32 1
  %38 = getelementptr inbounds %Vec2, ptr addrspace(5) %37, i32 0, i32 0
  %readtmp49 = load float, ptr addrspace(5) %38, align 4
  store float %readtmp49, ptr addrspace(5) %36, align 4
  %readtmp50 = load ptr addrspace(5), ptr %v, align 8
  %39 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp50, i32 0, i32 0
  %readtmp51 = load ptr addrspace(5), ptr addrspace(5) %39, align 8
  %elemtemp52 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp51, i32 0, i32 2
  %40 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp52, i32 0, i32 1
  %readtmp53 = load ptr addrspace(5), ptr %self, align 8
  %41 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp53, i32 0, i32 1
  %42 = getelementptr inbounds %Vec2, ptr addrspace(5) %41, i32 0, i32 1
  %readtmp54 = load float, ptr addrspace(5) %42, align 4
  %readtmp55 = load ptr addrspace(5), ptr %self, align 8
  %43 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp55, i32 0, i32 0
  %44 = getelementptr inbounds %Vec2, ptr addrspace(5) %43, i32 0, i32 1
  %readtmp56 = load float, ptr addrspace(5) %44, align 4
  %addtmp57 = fadd float %readtmp54, %readtmp56
  store float %addtmp57, ptr addrspace(5) %40, align 4
  %readtmp58 = load ptr addrspace(5), ptr %v, align 8
  %45 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp58, i32 0, i32 0
  %readtmp59 = load ptr addrspace(5), ptr addrspace(5) %45, align 8
  %elemtemp60 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp59, i32 0, i32 2
  %46 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp60, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %46, align 4
  %readtmp61 = load ptr addrspace(5), ptr %v, align 8
  %47 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp61, i32 0, i32 0
  %readtmp62 = load ptr addrspace(5), ptr addrspace(5) %47, align 8
  %elemtemp63 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp62, i32 0, i32 2
  %48 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp63, i32 0, i32 3
  store float 0.000000e+00, ptr addrspace(5) %48, align 4
  %readtmp64 = load ptr addrspace(5), ptr %v, align 8
  %49 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp64, i32 0, i32 0
  %readtmp65 = load ptr addrspace(5), ptr addrspace(5) %49, align 8
  %elemtemp66 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp65, i32 0, i32 2
  %50 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp66, i32 0, i32 4
  store float 1.000000e+00, ptr addrspace(5) %50, align 4
  %readtmp67 = load ptr addrspace(5), ptr %v, align 8
  %51 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp67, i32 0, i32 0
  %readtmp68 = load ptr addrspace(5), ptr addrspace(5) %51, align 8
  %elemtemp69 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp68, i32 0, i32 3
  %52 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp69, i32 0, i32 0
  %readtmp70 = load ptr addrspace(5), ptr %self, align 8
  %53 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp70, i32 0, i32 1
  %54 = getelementptr inbounds %Vec2, ptr addrspace(5) %53, i32 0, i32 0
  %readtmp71 = load float, ptr addrspace(5) %54, align 4
  store float %readtmp71, ptr addrspace(5) %52, align 4
  %readtmp72 = load ptr addrspace(5), ptr %v, align 8
  %55 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp72, i32 0, i32 0
  %readtmp73 = load ptr addrspace(5), ptr addrspace(5) %55, align 8
  %elemtemp74 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp73, i32 0, i32 3
  %56 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp74, i32 0, i32 1
  %readtmp75 = load ptr addrspace(5), ptr %self, align 8
  %57 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp75, i32 0, i32 1
  %58 = getelementptr inbounds %Vec2, ptr addrspace(5) %57, i32 0, i32 1
  %readtmp76 = load float, ptr addrspace(5) %58, align 4
  store float %readtmp76, ptr addrspace(5) %56, align 4
  %readtmp77 = load ptr addrspace(5), ptr %v, align 8
  %59 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp77, i32 0, i32 0
  %readtmp78 = load ptr addrspace(5), ptr addrspace(5) %59, align 8
  %elemtemp79 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp78, i32 0, i32 3
  %60 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp79, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %60, align 4
  %readtmp80 = load ptr addrspace(5), ptr %v, align 8
  %61 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp80, i32 0, i32 0
  %readtmp81 = load ptr addrspace(5), ptr addrspace(5) %61, align 8
  %elemtemp82 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp81, i32 0, i32 3
  %62 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp82, i32 0, i32 3
  store float 0.000000e+00, ptr addrspace(5) %62, align 4
  %readtmp83 = load ptr addrspace(5), ptr %v, align 8
  %63 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp83, i32 0, i32 0
  %readtmp84 = load ptr addrspace(5), ptr addrspace(5) %63, align 8
  %elemtemp85 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp84, i32 0, i32 3
  %64 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp85, i32 0, i32 4
  store float 0.000000e+00, ptr addrspace(5) %64, align 4
  %readtmp86 = load ptr addrspace(5), ptr %v, align 8
  %65 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp86, i32 0, i32 0
  %readtmp87 = load ptr addrspace(5), ptr addrspace(5) %65, align 8
  %elemtemp88 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp87, i32 0, i32 4
  %66 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp88, i32 0, i32 0
  %readtmp89 = load ptr addrspace(5), ptr %self, align 8
  %67 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp89, i32 0, i32 1
  %68 = getelementptr inbounds %Vec2, ptr addrspace(5) %67, i32 0, i32 0
  %readtmp90 = load float, ptr addrspace(5) %68, align 4
  %readtmp91 = load ptr addrspace(5), ptr %self, align 8
  %69 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp91, i32 0, i32 0
  %70 = getelementptr inbounds %Vec2, ptr addrspace(5) %69, i32 0, i32 0
  %readtmp92 = load float, ptr addrspace(5) %70, align 4
  %addtmp93 = fadd float %readtmp90, %readtmp92
  store float %addtmp93, ptr addrspace(5) %66, align 4
  %readtmp94 = load ptr addrspace(5), ptr %v, align 8
  %71 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp94, i32 0, i32 0
  %readtmp95 = load ptr addrspace(5), ptr addrspace(5) %71, align 8
  %elemtemp96 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp95, i32 0, i32 4
  %72 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp96, i32 0, i32 1
  %readtmp97 = load ptr addrspace(5), ptr %self, align 8
  %73 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp97, i32 0, i32 1
  %74 = getelementptr inbounds %Vec2, ptr addrspace(5) %73, i32 0, i32 1
  %readtmp98 = load float, ptr addrspace(5) %74, align 4
  %readtmp99 = load ptr addrspace(5), ptr %self, align 8
  %75 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp99, i32 0, i32 0
  %76 = getelementptr inbounds %Vec2, ptr addrspace(5) %75, i32 0, i32 1
  %readtmp100 = load float, ptr addrspace(5) %76, align 4
  %addtmp101 = fadd float %readtmp98, %readtmp100
  store float %addtmp101, ptr addrspace(5) %72, align 4
  %readtmp102 = load ptr addrspace(5), ptr %v, align 8
  %77 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp102, i32 0, i32 0
  %readtmp103 = load ptr addrspace(5), ptr addrspace(5) %77, align 8
  %elemtemp104 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp103, i32 0, i32 4
  %78 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp104, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %78, align 4
  %readtmp105 = load ptr addrspace(5), ptr %v, align 8
  %79 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp105, i32 0, i32 0
  %readtmp106 = load ptr addrspace(5), ptr addrspace(5) %79, align 8
  %elemtemp107 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp106, i32 0, i32 4
  %80 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp107, i32 0, i32 3
  store float 1.000000e+00, ptr addrspace(5) %80, align 4
  %readtmp108 = load ptr addrspace(5), ptr %v, align 8
  %81 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp108, i32 0, i32 0
  %readtmp109 = load ptr addrspace(5), ptr addrspace(5) %81, align 8
  %elemtemp110 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp109, i32 0, i32 4
  %82 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp110, i32 0, i32 4
  store float 1.000000e+00, ptr addrspace(5) %82, align 4
  %readtmp111 = load ptr addrspace(5), ptr %v, align 8
  %83 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp111, i32 0, i32 0
  %readtmp112 = load ptr addrspace(5), ptr addrspace(5) %83, align 8
  %elemtemp113 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp112, i32 0, i32 5
  %84 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp113, i32 0, i32 0
  %readtmp114 = load ptr addrspace(5), ptr %self, align 8
  %85 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp114, i32 0, i32 1
  %86 = getelementptr inbounds %Vec2, ptr addrspace(5) %85, i32 0, i32 0
  %readtmp115 = load float, ptr addrspace(5) %86, align 4
  %readtmp116 = load ptr addrspace(5), ptr %self, align 8
  %87 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp116, i32 0, i32 0
  %88 = getelementptr inbounds %Vec2, ptr addrspace(5) %87, i32 0, i32 0
  %readtmp117 = load float, ptr addrspace(5) %88, align 4
  %addtmp118 = fadd float %readtmp115, %readtmp117
  store float %addtmp118, ptr addrspace(5) %84, align 4
  %readtmp119 = load ptr addrspace(5), ptr %v, align 8
  %89 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp119, i32 0, i32 0
  %readtmp120 = load ptr addrspace(5), ptr addrspace(5) %89, align 8
  %elemtemp121 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp120, i32 0, i32 5
  %90 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp121, i32 0, i32 1
  %readtmp122 = load ptr addrspace(5), ptr %self, align 8
  %91 = getelementptr inbounds %Sprite, ptr addrspace(5) %readtmp122, i32 0, i32 1
  %92 = getelementptr inbounds %Vec2, ptr addrspace(5) %91, i32 0, i32 1
  %readtmp123 = load float, ptr addrspace(5) %92, align 4
  store float %readtmp123, ptr addrspace(5) %90, align 4
  %readtmp124 = load ptr addrspace(5), ptr %v, align 8
  %93 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp124, i32 0, i32 0
  %readtmp125 = load ptr addrspace(5), ptr addrspace(5) %93, align 8
  %elemtemp126 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp125, i32 0, i32 5
  %94 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp126, i32 0, i32 2
  store float 0.000000e+00, ptr addrspace(5) %94, align 4
  %readtmp127 = load ptr addrspace(5), ptr %v, align 8
  %95 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp127, i32 0, i32 0
  %readtmp128 = load ptr addrspace(5), ptr addrspace(5) %95, align 8
  %elemtemp129 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp128, i32 0, i32 5
  %96 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp129, i32 0, i32 3
  store float 1.000000e+00, ptr addrspace(5) %96, align 4
  %readtmp130 = load ptr addrspace(5), ptr %v, align 8
  %97 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp130, i32 0, i32 0
  %readtmp131 = load ptr addrspace(5), ptr addrspace(5) %97, align 8
  %elemtemp132 = getelementptr inbounds [3 x %Vert], ptr addrspace(5) %readtmp131, i32 0, i32 5
  %98 = getelementptr inbounds %Vert, ptr addrspace(5) %elemtemp132, i32 0, i32 4
  store float 0.000000e+00, ptr addrspace(5) %98, align 4
  %readtmp133 = load ptr addrspace(5), ptr %v, align 8
  ret ptr addrspace(5) %readtmp133
  store ptr @Sprite.getVerts_0, ptr %12, align 8
  %readtmp134 = load ptr addrspace(5), ptr %sb, align 8
  %99 = getelementptr inbounds %Bullet, ptr %self, i32 0, i32 1
  %readtmp135 = load %Drawer, ptr %99, align 8
}

define void @SpriteBatch.draw_0(ptr addrspace(5) %0, %Drawer %1) {
entry:
  %entry1 = alloca %SBQueueEntry, align 8
  %dr = alloca %Drawer, align 8
  %sb = alloca ptr addrspace(5), align 8
  store %Drawer %1, ptr %dr, align 8
  store ptr addrspace(5) %0, ptr %sb, align 8
  %2 = getelementptr inbounds %SBQueueEntry, ptr %entry1, i32 0, i32 0
  store i1 true, ptr %2, align 1
  %3 = getelementptr inbounds %SBQueueEntry, ptr %entry1, i32 0, i32 2
  %4 = getelementptr inbounds %Drawer, ptr %dr, i32 0, i32 1
  %readtmp = load ptr addrspace(5), ptr %4, align 8
  store ptr addrspace(5) %readtmp, ptr %3, align 8
  %5 = getelementptr inbounds %SBQueueEntry, ptr %entry1, i32 0, i32 3
  %6 = getelementptr inbounds %Drawer, ptr %dr, i32 0, i32 2
  %readtmp2 = load ptr addrspace(5), ptr %6, align 8
  store ptr addrspace(5) %readtmp2, ptr %5, align 8
  %7 = getelementptr inbounds %SBQueueEntry, ptr %entry1, i32 0, i32 4
}

define ptr addrspace(5) @Drawer.genVerts_0(ptr addrspace(5) %0) {
entry:
  %readtmp = load %Drawer, ptr addrspace(5) %0, align 8
  %extracted = extractvalue %Drawer %readtmp, 3
  %readtmp1 = load %Drawer, ptr addrspace(5) %0, align 8
  %extracted2 = extractvalue %Drawer %readtmp1, 0
  %calltmp = call addrspace(5) ptr addrspace(5) %extracted2(ptr addrspace(5) %extracted)
  ret ptr addrspace(5) %calltmp
  %calltmp3 = call ptr addrspace(5) @Drawer.genVerts_0(ptr %dr)
  store ptr addrspace(5) %calltmp3, ptr %7, align 8
  %old = alloca i32, align 4
  %readtmp4 = load ptr addrspace(5), ptr %sb, align 8
  %1 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp4, i32 0, i32 1
  %readtmp5 = load ptr addrspace(5), ptr addrspace(5) %1, align 8
  %2 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp5, i32 0, i32 1
  %readtmp6 = load i32, ptr addrspace(5) %2, align 4
  store i32 %readtmp6, ptr %old, align 4
  %readtmp7 = load ptr addrspace(5), ptr %sb, align 8
  %3 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp7, i32 0, i32 1
  %readtmp8 = load ptr addrspace(5), ptr addrspace(5) %3, align 8
  %4 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp8, i32 0, i32 1
  %readtmp9 = load ptr addrspace(5), ptr %sb, align 8
  %5 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp9, i32 0, i32 1
  %readtmp10 = load ptr addrspace(5), ptr addrspace(5) %5, align 8
  %6 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp10, i32 0, i32 1
  %readtmp11 = load i32, ptr addrspace(5) %6, align 4
  %addtmp = add i32 %readtmp11, 1
  store i32 %addtmp, ptr addrspace(5) %4, align 4
  %readtmp12 = load ptr addrspace(5), ptr %sb, align 8
  %7 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp12, i32 0, i32 1
  %readtmp13 = load ptr addrspace(5), ptr addrspace(5) %7, align 8
  %8 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp13, i32 0, i32 0
  %readtmp14 = load ptr addrspace(5), ptr %sb, align 8
  %9 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp14, i32 0, i32 1
  %readtmp15 = load ptr addrspace(5), ptr addrspace(5) %9, align 8
  %10 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp15, i32 0, i32 0
  %readtmp16 = load ptr addrspace(5), ptr addrspace(5) %10, align 8
  %readtmp17 = load ptr addrspace(5), ptr %sb, align 8
  %11 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp17, i32 0, i32 1
  %readtmp18 = load ptr addrspace(5), ptr addrspace(5) %11, align 8
}

define i32 @SBQueue.getSize_0(ptr addrspace(5) %0) {
entry:
  %readtmp = load %SBQueue, ptr addrspace(5) %0, align 8
  %extracted = extractvalue %SBQueue %readtmp, 1
  %multmp = mul i32 %extracted, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %SBQueueEntry], ptr addrspace(5) null, i32 1) to i32)
  ret i32 %multmp
  %calltmp = call i32 @SBQueue.getSize_0(ptr addrspace(5) %readtmp18)
  %calltmp1 = call ptr addrspace(5) @realloc(ptr addrspace(5) %readtmp16, i32 %calltmp)
  store ptr addrspace(5) %calltmp1, ptr addrspace(5) %8, align 8
  %readtmp2 = load ptr addrspace(5), ptr %sb, align 8
  %1 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp2, i32 0, i32 1
  %readtmp3 = load ptr addrspace(5), ptr addrspace(5) %1, align 8
  %readtmp4 = load i32, ptr %old, align 4
}

define ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %0, i32 %1) {
entry:
  %q = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %q, align 8
  %multmp = mul i32 %1, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %SBQueueEntry], ptr addrspace(5) null, i32 1) to i32)
  %readtmp = load ptr addrspace(5), ptr %q, align 8
  %2 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp, i32 0, i32 0
  %readtmp1 = load ptr addrspace(5), ptr addrspace(5) %2, align 8
}

define ptr addrspace(5) @mem.add_3(ptr addrspace(5) %0, i64 %1) {
entry:
  %addtmp = add i64 %1, ptr addrspace(5) %0
  ret i64 %addtmp
  %calltmp = call ptr addrspace(5) @mem.add_3(ptr addrspace(5) %readtmp1, i32 %multmp)
  ret ptr addrspace(5) %calltmp
  %calltmp1 = call ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %readtmp3, i32 %readtmp4)
  %readtmp = load %SBQueueEntry, ptr %entry1, align 8
  store %SBQueueEntry %readtmp, ptr addrspace(5) %calltmp1, align 8
  ret void
  %calltmp2 = call void @SpriteBatch.draw_0(ptr addrspace(5) %readtmp134, %Drawer %readtmp135)
  ret void
  %calltmp3 = call void @Bullet.draw_0(%Bullet %readtmp6, ptr addrspace(5) %readtmp7, ptr addrspace(5) %readtmp9, ptr addrspace(5) %readtmp11)
  %readtmp4 = load i32, ptr %idx, align 4
  %addtmp5 = add i32 %readtmp4, 1
  store i32 %addtmp5, ptr %idx, align 4
  %readtmp6 = load i32, ptr %idx, align 4
  %readtmp7 = load ptr addrspace(5), ptr %self, align 8
  %2 = getelementptr inbounds %BulletManager, ptr addrspace(5) %readtmp7, i32 0, i32 1
  %readtmp8 = load i32, ptr addrspace(5) %2, align 4
  %lttmp = icmp ult i32 %readtmp6, %readtmp8
  %docond = icmp ne i1 %lttmp, false
  br i1 %docond, label %dobody, label %domerge
}

define void @GFXContext.clear_0(ptr addrspace(5) %0) {
entry:
  %ctx = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %ctx, align 8
  %readtmp = load ptr addrspace(5), ptr %ctx, align 8
  %1 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp, i32 0, i32 1
  %2 = getelementptr inbounds %Color, ptr addrspace(5) %1, i32 0, i32 0
  %readtmp1 = load float, ptr addrspace(5) %2, align 4
  %readtmp2 = load ptr addrspace(5), ptr %ctx, align 8
  %3 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp2, i32 0, i32 1
  %4 = getelementptr inbounds %Color, ptr addrspace(5) %3, i32 0, i32 1
  %readtmp3 = load float, ptr addrspace(5) %4, align 4
  %readtmp4 = load ptr addrspace(5), ptr %ctx, align 8
  %5 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp4, i32 0, i32 1
  %6 = getelementptr inbounds %Color, ptr addrspace(5) %5, i32 0, i32 2
  %readtmp5 = load float, ptr addrspace(5) %6, align 4
  %readtmp6 = load ptr addrspace(5), ptr %ctx, align 8
  %7 = getelementptr inbounds %GFXContext, ptr addrspace(5) %readtmp6, i32 0, i32 1
  %8 = getelementptr inbounds %Color, ptr addrspace(5) %7, i32 0, i32 3
  %readtmp7 = load float, ptr addrspace(5) %8, align 4
  %calltmp = call void @glClearColor(float %readtmp1, float %readtmp3, float %readtmp5, float %readtmp7)
  %calltmp8 = call void @glClear(i32 16384)
  ret void
  %calltmp9 = call void @GFXContext.clear_0(ptr addrspace(5) %readtmp27)
}

define void @SpriteBatch.finish_0(ptr addrspace(5) %0) {
entry:
  %sb = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %sb, align 8
  %idx = alloca i32, align 4
  %readtmp = load ptr addrspace(5), ptr %sb, align 8
  %1 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp, i32 0, i32 1
  %readtmp1 = load ptr addrspace(5), ptr addrspace(5) %1, align 8
  %2 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp1, i32 0, i32 1
  %ifcond = icmp ne ptr addrspace(5) %2, i1 false
  br i1 %ifcond, label %ifbody, label %ifmerge

ifbody:                                           ; preds = %entry
  store i32 0, ptr %idx, align 4
  br label %dobody

ifmerge:                                          ; preds = %domerge, %entry
  %calltmp34 = call void @glEnable(i32 3042)
  %calltmp35 = call void @glBlendFunc(i32 770, i32 771)
  %readtmp36 = load ptr addrspace(5), ptr %sb, align 8
  %3 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp36, i32 0, i32 3
  %readtmp37 = load i32, ptr addrspace(5) %3, align 4
  %readtmp38 = load ptr addrspace(5), ptr %sb, align 8
  %4 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp38, i32 0, i32 1
  %readtmp39 = load ptr addrspace(5), ptr addrspace(5) %4, align 8
  %5 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp39, i32 0, i32 1
  %readtmp40 = load i32, ptr addrspace(5) %5, align 4
  %eqtmp41 = icmp ne i32 %readtmp40, %readtmp37
  %ifcond42 = icmp ne i1 %eqtmp41, false
  br i1 %ifcond42, label %ifbody43, label %ifmerge44

dobody:                                           ; preds = %ifmerge14, %ifbody
  %readtmp2 = load ptr addrspace(5), ptr %sb, align 8
  %6 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp2, i32 0, i32 1
  %readtmp3 = load ptr addrspace(5), ptr addrspace(5) %6, align 8
  %readtmp4 = load i32, ptr %idx, align 4
  %calltmp = call ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %readtmp3, i32 %readtmp4)
  %7 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %calltmp, i32 0, i32 0
  store i1 true, ptr addrspace(5) %7, align 1
  %readtmp5 = load ptr addrspace(5), ptr %sb, align 8
  %8 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp5, i32 0, i32 1
  %readtmp6 = load ptr addrspace(5), ptr addrspace(5) %8, align 8
  %readtmp7 = load i32, ptr %idx, align 4
  %calltmp8 = call ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %readtmp6, i32 %readtmp7)
  %9 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %calltmp8, i32 0, i32 1
  %readtmp9 = load ptr addrspace(5), ptr %sb, align 8
  %10 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp9, i32 0, i32 1
  %readtmp10 = load ptr addrspace(5), ptr addrspace(5) %10, align 8
  %readtmp11 = load i32, ptr %idx, align 4
  %calltmp12 = call ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %readtmp10, i32 %readtmp11)

domerge:                                          ; preds = %ifmerge14
  br label %ifmerge

ifbody13:                                         ; preds = %domerge
  %readtmp15 = load ptr addrspace(5), ptr %sb, align 8
  %11 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp15, i32 0, i32 1
  %readtmp16 = load ptr addrspace(5), ptr addrspace(5) %11, align 8
  %readtmp17 = load i32, ptr %idx, align 4
  %calltmp18 = call ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %readtmp16, i32 %readtmp17)
  %12 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %calltmp18, i32 0, i32 0
  %readtmp19 = load ptr addrspace(5), ptr %sb, align 8
  %13 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp19, i32 0, i32 1
  %readtmp20 = load ptr addrspace(5), ptr addrspace(5) %13, align 8
  %readtmp21 = load i32, ptr %idx, align 4
  %calltmp22 = call ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %readtmp20, i32 %readtmp21)
  %14 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %calltmp22, i32 0, i32 1
  %readtmp23 = load i64, ptr addrspace(5) %14, align 4
  %readtmp24 = load ptr addrspace(5), ptr %sb, align 8
  %15 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp24, i32 0, i32 0
  %readtmp25 = load ptr addrspace(5), ptr addrspace(5) %15, align 8
  %readtmp26 = load i32, ptr %idx, align 4
  %calltmp27 = call ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %readtmp25, i32 %readtmp26)
  %16 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %calltmp27, i32 0, i32 1
  %readtmp28 = load i64, ptr addrspace(5) %16, align 4
  %eqtmp = icmp ne i64 %readtmp28, %readtmp23
  store i1 %eqtmp, ptr addrspace(5) %12, align 1
  br label %ifmerge14

ifmerge14:                                        ; preds = %ifbody13, %domerge
  %readtmp29 = load i32, ptr %idx, align 4
  %addtmp = add i32 %readtmp29, 1
  store i32 %addtmp, ptr %idx, align 4
  %readtmp30 = load i32, ptr %idx, align 4
  %readtmp31 = load ptr addrspace(5), ptr %sb, align 8
  %17 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp31, i32 0, i32 1
  %readtmp32 = load ptr addrspace(5), ptr addrspace(5) %17, align 8
  %18 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp32, i32 0, i32 1
  %readtmp33 = load i32, ptr addrspace(5) %18, align 4
  %lttmp = icmp ult i32 %readtmp30, %readtmp33
  %docond = icmp ne i1 %lttmp, false
  br i1 %docond, label %dobody, label %domerge

ifbody43:                                         ; preds = %ifmerge
  %target = alloca i32, align 4
  %readtmp45 = load ptr addrspace(5), ptr %sb, align 8
  %19 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp45, i32 0, i32 1
  %readtmp46 = load ptr addrspace(5), ptr addrspace(5) %19, align 8
  %20 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp46, i32 0, i32 1
  %readtmp47 = load i32, ptr addrspace(5) %20, align 4
  store i32 %readtmp47, ptr %target, align 4
  %readtmp48 = load i32, ptr %target, align 4
  %readtmp49 = load ptr addrspace(5), ptr %sb, align 8
  %21 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp49, i32 0, i32 3
  %readtmp50 = load i32, ptr addrspace(5) %21, align 4
  %lttmp51 = icmp ult i32 %readtmp48, %readtmp50
  %ifcond52 = icmp ne i1 %lttmp51, false
  br i1 %ifcond52, label %ifbody53, label %ifmerge54

ifmerge44:                                        ; preds = %ifmerge72, %ifmerge
  %ctx = alloca %SBContext, align 8
  %entry86 = alloca ptr addrspace(5), align 8
  %22 = getelementptr inbounds %SBContext, ptr %ctx, i32 0, i32 0
  store i64 0, ptr %22, align 4
  %23 = getelementptr inbounds %SBContext, ptr %ctx, i32 0, i32 1
  store i64 0, ptr %23, align 4
  %readtmp87 = load ptr addrspace(5), ptr %sb, align 8
  %24 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp87, i32 0, i32 1
  %readtmp88 = load ptr addrspace(5), ptr addrspace(5) %24, align 8
  %25 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp88, i32 0, i32 1
  %readtmp89 = load i32, ptr addrspace(5) %25, align 4
  %eqtmp90 = icmp ne i32 0, %readtmp89
  %ifcond91 = icmp ne i1 %eqtmp90, false
  br i1 %ifcond91, label %ifbody92, label %ifmerge93

ifbody53:                                         ; preds = %ifbody43
  %readtmp55 = load ptr addrspace(5), ptr %sb, align 8
  %26 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp55, i32 0, i32 3
  %readtmp56 = load i32, ptr addrspace(5) %26, align 4
  %readtmp57 = load i32, ptr %target, align 4
  %subtmp = sub i32 %readtmp56, %readtmp57
  %readtmp58 = load ptr addrspace(5), ptr %sb, align 8
  %27 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp58, i32 0, i32 2
  %readtmp59 = load ptr addrspace(5), ptr addrspace(5) %27, align 8
  %readtmp60 = load i32, ptr %target, align 4
  %multmp = mul i32 %readtmp60, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x i32], ptr addrspace(5) null, i32 1) to i32)

ifmerge54:                                        ; preds = %entry, %ifbody43
  %readtmp61 = load ptr addrspace(5), ptr %sb, align 8
  %28 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp61, i32 0, i32 2
  %readtmp62 = load ptr addrspace(5), ptr %sb, align 8
  %29 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp62, i32 0, i32 2
  %readtmp63 = load ptr addrspace(5), ptr addrspace(5) %29, align 8
  %readtmp64 = load i32, ptr %target, align 4
  %multmp65 = mul i32 %readtmp64, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x i32], ptr addrspace(5) null, i32 1) to i32)
  %calltmp66 = call ptr addrspace(5) @realloc(ptr addrspace(5) %readtmp63, i32 %multmp65)
  store ptr addrspace(5) %calltmp66, ptr addrspace(5) %28, align 8
  %readtmp67 = load i32, ptr %target, align 4
  %readtmp68 = load ptr addrspace(5), ptr %sb, align 8
  %30 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp68, i32 0, i32 3
  %readtmp69 = load i32, ptr addrspace(5) %30, align 4
  %gttmp = icmp ugt i32 %readtmp67, %readtmp69
  %ifcond70 = icmp ne i1 %gttmp, false
  br i1 %ifcond70, label %ifbody71, label %ifmerge72

ifbody71:                                         ; preds = %ifmerge54
  %readtmp73 = load i32, ptr %target, align 4
  %readtmp74 = load ptr addrspace(5), ptr %sb, align 8
  %31 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp74, i32 0, i32 3
  %readtmp75 = load i32, ptr addrspace(5) %31, align 4
  %subtmp76 = sub i32 %readtmp73, %readtmp75
  %readtmp77 = load ptr addrspace(5), ptr %sb, align 8
  %32 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp77, i32 0, i32 2
  %readtmp78 = load ptr addrspace(5), ptr addrspace(5) %32, align 8
  %readtmp79 = load ptr addrspace(5), ptr %sb, align 8
  %33 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp79, i32 0, i32 3
  %readtmp80 = load i32, ptr addrspace(5) %33, align 4
  %multmp81 = mul i32 %readtmp80, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x i32], ptr addrspace(5) null, i32 1) to i32)
  %calltmp82 = call ptr addrspace(5) @mem.add_5(ptr addrspace(5) %readtmp78, i32 %multmp81)
  %calltmp83 = call void @glGenBuffers(i32 %subtmp76, ptr addrspace(5) %calltmp82)
  br label %ifmerge72

ifmerge72:                                        ; preds = %ifbody71, %ifmerge54
  %readtmp84 = load ptr addrspace(5), ptr %sb, align 8
  %34 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp84, i32 0, i32 3
  %readtmp85 = load i32, ptr %target, align 4
  store i32 %readtmp85, ptr addrspace(5) %34, align 4
  br label %ifmerge44

ifbody92:                                         ; preds = %ifmerge44
  store i32 0, ptr %idx, align 4
  br label %dobody94

ifmerge93:                                        ; preds = %domerge95, %ifmerge44
  %readtmp176 = load ptr addrspace(5), ptr %sb, align 8
  %35 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp176, i32 0, i32 0
  %readtmp177 = load ptr addrspace(5), ptr addrspace(5) %35, align 8
  %calltmp178 = call void @free(ptr addrspace(5) %readtmp177)
  %readtmp179 = load ptr addrspace(5), ptr %sb, align 8
  %36 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp179, i32 0, i32 0
  %readtmp180 = load ptr addrspace(5), ptr %sb, align 8
  %37 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp180, i32 0, i32 1
  %readtmp181 = load ptr addrspace(5), ptr addrspace(5) %37, align 8
  store ptr addrspace(5) %readtmp181, ptr addrspace(5) %36, align 8
  %readtmp182 = load ptr addrspace(5), ptr %sb, align 8
  %38 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp182, i32 0, i32 1
  %calltmp183 = call ptr addrspace(5) @malloc(i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %SBQueue], ptr addrspace(5) null, i32 1) to i32))
  store ptr addrspace(5) %calltmp183, ptr addrspace(5) %38, align 8
  %readtmp184 = load ptr addrspace(5), ptr %sb, align 8
  %39 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp184, i32 0, i32 1
  %readtmp185 = load ptr addrspace(5), ptr addrspace(5) %39, align 8
  %40 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp185, i32 0, i32 0
  store i64 0, ptr addrspace(5) %40, align 4
  %readtmp186 = load ptr addrspace(5), ptr %sb, align 8
  %41 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp186, i32 0, i32 1
  %readtmp187 = load ptr addrspace(5), ptr addrspace(5) %41, align 8
  %42 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp187, i32 0, i32 1
  store i32 0, ptr addrspace(5) %42, align 4
  ret void
  %calltmp188 = call void @SpriteBatch.finish_0(ptr %sb)
  %readtmp189 = load ptr addrspace(5), ptr %ctx, align 8

dobody94:                                         ; preds = %ifmerge149, %ifbody92
  %readtmp96 = load ptr addrspace(5), ptr %sb, align 8
  %43 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp96, i32 0, i32 1
  %readtmp97 = load ptr addrspace(5), ptr addrspace(5) %43, align 8
  %readtmp98 = load i32, ptr %idx, align 4
  %calltmp99 = call ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %readtmp97, i32 %readtmp98)
  store ptr addrspace(5) %calltmp99, ptr %entry86, align 8
  %readtmp100 = load %SBContext, ptr %ctx, align 8
  %extracted = extractvalue %SBContext %readtmp100, 0
  %readtmp101 = load ptr addrspace(5), ptr %entry86, align 8
  %44 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp101, i32 0, i32 2
  %readtmp102 = load ptr addrspace(5), ptr addrspace(5) %44, align 8
  %eqtmp103 = icmp ne ptr addrspace(5) %readtmp102, %extracted
  %ifcond104 = icmp ne i1 %eqtmp103, false
  br i1 %ifcond104, label %ifbody105, label %ifmerge106

domerge95:                                        ; preds = %ifmerge149
  br label %ifmerge93

ifbody105:                                        ; preds = %dobody94
  %readtmp107 = load ptr addrspace(5), ptr %entry86, align 8
  %45 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp107, i32 0, i32 2
  %readtmp108 = load ptr addrspace(5), ptr addrspace(5) %45, align 8
  %46 = getelementptr inbounds %Texture, ptr addrspace(5) %readtmp108, i32 0, i32 0
  %readtmp109 = load i32, ptr addrspace(5) %46, align 4
  %calltmp110 = call void @glBindTexture(i32 3553, i32 %readtmp109)
  br label %ifmerge106

ifmerge106:                                       ; preds = %ifbody105, %dobody94
  %47 = getelementptr inbounds %SBContext, ptr %ctx, i32 0, i32 0
  %readtmp111 = load ptr addrspace(5), ptr %sb, align 8
  %48 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp111, i32 0, i32 1
  %readtmp112 = load ptr addrspace(5), ptr addrspace(5) %48, align 8
  %readtmp113 = load i32, ptr %idx, align 4
  %calltmp114 = call ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %readtmp112, i32 %readtmp113)
  %49 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %calltmp114, i32 0, i32 2
  %readtmp115 = load ptr addrspace(5), ptr addrspace(5) %49, align 8
  store ptr addrspace(5) %readtmp115, ptr %47, align 8
  %readtmp116 = load %SBContext, ptr %ctx, align 8
  %extracted117 = extractvalue %SBContext %readtmp116, 1
  %readtmp118 = load ptr addrspace(5), ptr %entry86, align 8
  %50 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp118, i32 0, i32 3
  %readtmp119 = load ptr addrspace(5), ptr addrspace(5) %50, align 8
  %eqtmp120 = icmp ne ptr addrspace(5) %readtmp119, %extracted117
  %ifcond121 = icmp ne i1 %eqtmp120, false
  br i1 %ifcond121, label %ifbody122, label %ifmerge123

ifbody122:                                        ; preds = %ifmerge106
  %readtmp124 = load ptr addrspace(5), ptr %entry86, align 8
  %51 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp124, i32 0, i32 3
  %readtmp125 = load ptr addrspace(5), ptr addrspace(5) %51, align 8
  %52 = getelementptr inbounds %Shader, ptr addrspace(5) %readtmp125, i32 0, i32 0
  %readtmp126 = load i32, ptr addrspace(5) %52, align 4
  %calltmp127 = call void @glUseProgram(i32 %readtmp126)
  br label %ifmerge123

ifmerge123:                                       ; preds = %ifbody122, %ifmerge106
  %53 = getelementptr inbounds %SBContext, ptr %ctx, i32 0, i32 1
  %readtmp128 = load ptr addrspace(5), ptr %sb, align 8
  %54 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp128, i32 0, i32 1
  %readtmp129 = load ptr addrspace(5), ptr addrspace(5) %54, align 8
  %readtmp130 = load i32, ptr %idx, align 4
  %calltmp131 = call ptr addrspace(5) @SBQueue.getEntry_0(ptr addrspace(5) %readtmp129, i32 %readtmp130)
  %55 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %calltmp131, i32 0, i32 3
  %readtmp132 = load ptr addrspace(5), ptr addrspace(5) %55, align 8
  store ptr addrspace(5) %readtmp132, ptr %53, align 8
  %readtmp133 = load ptr addrspace(5), ptr %sb, align 8
  %56 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp133, i32 0, i32 2
  %readtmp134 = load ptr addrspace(5), ptr addrspace(5) %56, align 8
  %readtmp135 = load i32, ptr %idx, align 4
  %multmp136 = mul i32 %readtmp135, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x i32], ptr addrspace(5) null, i32 1) to i32)
  %calltmp137 = call ptr addrspace(5) @mem.add_5(ptr addrspace(5) %readtmp134, i32 %multmp136)
  %readtmp138 = load i32, ptr addrspace(5) %calltmp137, align 4
  %calltmp139 = call void @glBindBuffer(i32 34962, i32 %readtmp138)
  %readtmp140 = load ptr addrspace(5), ptr %entry86, align 8
  %57 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp140, i32 0, i32 0
  %readtmp141 = load i1, ptr addrspace(5) %57, align 1
  %readtmp142 = load ptr addrspace(5), ptr %entry86, align 8
  %58 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp142, i32 0, i32 4
  %readtmp143 = load ptr addrspace(5), ptr addrspace(5) %58, align 8
  %59 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp143, i32 0, i32 1
  %readtmp144 = load i32, ptr addrspace(5) %59, align 4
  %eqtmp145 = icmp ne i32 0, %readtmp144
  %subtmp146 = and i1 %readtmp141, %eqtmp145
  %ifcond147 = icmp ne i1 %subtmp146, false
  br i1 %ifcond147, label %ifbody148, label %ifmerge149

ifbody148:                                        ; preds = %ifmerge123
  %readtmp150 = load ptr addrspace(5), ptr %entry86, align 8
  %60 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp150, i32 0, i32 4
  %readtmp151 = load ptr addrspace(5), ptr addrspace(5) %60, align 8
  %61 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp151, i32 0, i32 1
  %readtmp152 = load i32, ptr addrspace(5) %61, align 4
  %multmp153 = mul i32 %readtmp152, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Vert], ptr addrspace(5) null, i32 1) to i32)
  %readtmp154 = load ptr addrspace(5), ptr %entry86, align 8
  %62 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp154, i32 0, i32 4
  %readtmp155 = load ptr addrspace(5), ptr addrspace(5) %62, align 8
  %63 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp155, i32 0, i32 0
  %readtmp156 = load ptr addrspace(5), ptr addrspace(5) %63, align 8
  %calltmp157 = call void @glBufferData(i32 34962, i32 %multmp153, ptr addrspace(5) %readtmp156, i32 35048)
  br label %ifmerge149

ifmerge149:                                       ; preds = %ifbody148, %ifmerge123
  %calltmp158 = call void @glVertexAttribPointer(i32 0, i32 3, i32 5126, i32 0, i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Vert], ptr addrspace(5) null, i32 1) to i32), i32 0)
  %calltmp159 = call void @glVertexAttribPointer(i32 1, i32 2, i32 5126, i32 0, i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Vert], ptr addrspace(5) null, i32 1) to i32), i32 mul (i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x float], ptr addrspace(5) null, i32 1) to i32), i32 3))
  %calltmp160 = call void @glVertexAttribPointer(i32 2, i32 4, i32 5126, i32 0, i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Vert], ptr addrspace(5) null, i32 1) to i32), i32 mul (i32 ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x float], ptr addrspace(5) null, i32 1) to i32), i32 5))
  %calltmp161 = call void @glEnableVertexAttribArray(i32 0)
  %calltmp162 = call void @glEnableVertexAttribArray(i32 1)
  %calltmp163 = call void @glEnableVertexAttribArray(i32 2)
  %readtmp164 = load ptr addrspace(5), ptr %entry86, align 8
  %64 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp164, i32 0, i32 4
  %readtmp165 = load ptr addrspace(5), ptr addrspace(5) %64, align 8
  %65 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp165, i32 0, i32 1
  %readtmp166 = load i32, ptr addrspace(5) %65, align 4
  %calltmp167 = call void @glDrawArrays(i32 4, i32 0, i32 %readtmp166)
  %readtmp168 = load i32, ptr %idx, align 4
  %addtmp169 = add i32 %readtmp168, 1
  store i32 %addtmp169, ptr %idx, align 4
  %readtmp170 = load i32, ptr %idx, align 4
  %readtmp171 = load ptr addrspace(5), ptr %sb, align 8
  %66 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp171, i32 0, i32 1
  %readtmp172 = load ptr addrspace(5), ptr addrspace(5) %66, align 8
  %67 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp172, i32 0, i32 1
  %readtmp173 = load i32, ptr addrspace(5) %67, align 4
  %lttmp174 = icmp ult i32 %readtmp170, %readtmp173
  %docond175 = icmp ne i1 %lttmp174, false
  br i1 %docond175, label %dobody94, label %domerge95
}

define i64 @SBQueueEntry.getHash_0(ptr addrspace(5) %0) {
entry:
  %entry1 = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %entry1, align 8
  %readtmp = load ptr addrspace(5), ptr %entry1, align 8
  %1 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp, i32 0, i32 2
  %readtmp2 = load ptr addrspace(5), ptr addrspace(5) %1, align 8
  %readtmp3 = load ptr addrspace(5), ptr %entry1, align 8
  %2 = getelementptr inbounds %SBQueueEntry, ptr addrspace(5) %readtmp3, i32 0, i32 4
  %readtmp4 = load ptr addrspace(5), ptr addrspace(5) %2, align 8
}

define i64 @Verts.getHash_0(ptr addrspace(5) %0) {
entry:
  %verts = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %verts, align 8
  %readtmp = load ptr addrspace(5), ptr %verts, align 8
  %1 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp, i32 0, i32 0
  %readtmp1 = load ptr addrspace(5), ptr addrspace(5) %1, align 8
  %readtmp2 = load ptr addrspace(5), ptr %verts, align 8
  %2 = getelementptr inbounds %Verts, ptr addrspace(5) %readtmp2, i32 0, i32 1
  %readtmp3 = load i32, ptr addrspace(5) %2, align 4
  %multmp = mul i32 %readtmp3, ptrtoint (ptr addrspace(5) getelementptr inbounds ([1 x %Vert], ptr addrspace(5) null, i32 1) to i32)
}

define i64 @Hash.get_0(ptr addrspace(5) %0, i32 %1) {
entry:
  %result = alloca i64, align 8
  %idx = alloca i32, align 4
  %str = alloca ptr addrspace(5), align 8
  %c = alloca i64, align 8
  %neqtmp = icmp eq i32 0, %1
  %ifcond = icmp ne i1 %neqtmp, false
  br i1 %ifcond, label %ifbody, label %ifmerge

ifbody:                                           ; preds = %entry
  ret i64 0
  br label %ifmerge

ifmerge:                                          ; preds = %ifbody, %entry
  store i32 %1, ptr %idx, align 4
  store ptr addrspace(5) %0, ptr %str, align 8
  store i64 5381, ptr %result, align 4
  br label %dobody

dobody:                                           ; preds = %entry, %ifmerge
  %readtmp = load ptr addrspace(5), ptr %str, align 8
  %readtmp1 = load i32, ptr %idx, align 4

domerge:                                          ; preds = %entry
  %readtmp2 = load i64, ptr %result, align 4
  ret i64 %readtmp2
  %calltmp = call i64 @Hash.get_0(ptr addrspace(5) %readtmp1, i32 %multmp)
  ret i64 %calltmp
  %calltmp3 = call i64 @Verts.getHash_0(ptr addrspace(5) %readtmp4)
  %addtmp = add ptr addrspace(5) %readtmp2, i64 %calltmp3
  ret ptr addrspace(5) %addtmp
  %calltmp4 = call i64 @SBQueueEntry.getHash_0(ptr addrspace(5) %calltmp12)
  store i64 %calltmp4, ptr addrspace(5) %9, align 4
  %readtmp5 = load i32, ptr %idx, align 4
  %readtmp6 = load ptr addrspace(5), ptr %sb, align 8
  %2 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp6, i32 0, i32 0
  %readtmp7 = load ptr addrspace(5), ptr addrspace(5) %2, align 8
  %3 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp7, i32 0, i32 1
  %readtmp8 = load i32, ptr addrspace(5) %3, align 4
  %lttmp = icmp ult i32 %readtmp5, %readtmp8
  %ifcond9 = icmp ne i1 %lttmp, false
  br i1 %ifcond9, label %ifbody13, label %ifmerge14
}

define ptr addrspace(5) @mem.add_4(ptr addrspace(5) %0, i64 %1) {
entry:
  %addtmp = add i64 %1, ptr addrspace(5) %0
  ret i64 %addtmp
  %calltmp = call ptr addrspace(5) @mem.add_4(ptr addrspace(5) %readtmp, i32 %readtmp1)
  %readtmp = load i8, ptr addrspace(5) %calltmp, align 1
  store i8 %readtmp, ptr %c, align 1
  %readtmp1 = load i64, ptr %result, align 4
  %subtmp = shl i64 %readtmp1, 5
  %readtmp2 = load i64, ptr %result, align 4
  %addtmp3 = add i64 %subtmp, %readtmp2
  %readtmp4 = load i64, ptr %c, align 4
  %addtmp5 = add i64 %addtmp3, %readtmp4
  store i64 %addtmp5, ptr %result, align 4
  %readtmp6 = load i32, ptr %idx, align 4
  %subtmp7 = sub i32 %readtmp6, 1
  store i32 %subtmp7, ptr %idx, align 4
  %readtmp8 = load i32, ptr %idx, align 4
  %gttmp = icmp ugt i32 %readtmp8, 0
  %docond = icmp ne i1 %gttmp, false
  br i1 %docond, label %dobody, label %domerge
}

define ptr addrspace(5) @mem.add_5(ptr addrspace(5) %0, i64 %1) {
entry:
  %addtmp = add i64 %1, ptr addrspace(5) %0
  ret i64 %addtmp
  %calltmp = call ptr addrspace(5) @mem.add_5(ptr addrspace(5) %readtmp59, i32 %multmp)
  %calltmp1 = call void @glDeleteBuffers(i32 %subtmp, ptr addrspace(5) %calltmp)
  br label %ifmerge54
}

define void @GFXContext.swap_0(ptr addrspace(5) %0) {
entry:
  %1 = getelementptr inbounds %GFXContext, ptr addrspace(5) %0, i32 0, i32 0
  %readtmp = load ptr addrspace(5), ptr addrspace(5) %1, align 8
  %calltmp = call void @glfwSwapBuffers(ptr addrspace(5) %readtmp)
  ret void
  %calltmp1 = call void @GFXContext.swap_0(ptr addrspace(5) %readtmp189)
  %readtmp2 = load ptr addrspace(5), ptr %ctx, align 8
}

define i1 @GFXContext.poll_0(ptr addrspace(5) %0) {
entry:
  %calltmp = call void @glfwPollEvents()
  %1 = getelementptr inbounds %GFXContext, ptr addrspace(5) %0, i32 0, i32 0
  %readtmp = load ptr addrspace(5), ptr addrspace(5) %1, align 8
  %calltmp1 = call i1 @glfwWindowShouldClose(ptr addrspace(5) %readtmp)
  %nottmp = xor i1 %calltmp1, true
  ret i1 %nottmp
  %calltmp2 = call i1 @GFXContext.poll_0(ptr addrspace(5) %readtmp2)
  %docond = icmp ne i1 %calltmp2, false
  br i1 %docond, label %dobody, label %domerge
}

define void @SpriteBatch.deinit_0(ptr addrspace(5) %0) {
entry:
  %sb = alloca ptr addrspace(5), align 8
  store ptr addrspace(5) %0, ptr %sb, align 8
  %readtmp = load ptr addrspace(5), ptr %sb, align 8
  %1 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp, i32 0, i32 1
  %readtmp1 = load ptr addrspace(5), ptr addrspace(5) %1, align 8
  %2 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp1, i32 0, i32 0
  %readtmp2 = load ptr addrspace(5), ptr addrspace(5) %2, align 8
  %calltmp = call void @free(ptr addrspace(5) %readtmp2)
  %readtmp3 = load ptr addrspace(5), ptr %sb, align 8
  %3 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp3, i32 0, i32 1
  %readtmp4 = load ptr addrspace(5), ptr addrspace(5) %3, align 8
  %calltmp5 = call void @free(ptr addrspace(5) %readtmp4)
  %readtmp6 = load ptr addrspace(5), ptr %sb, align 8
  %4 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp6, i32 0, i32 0
  %readtmp7 = load ptr addrspace(5), ptr addrspace(5) %4, align 8
  %5 = getelementptr inbounds %SBQueue, ptr addrspace(5) %readtmp7, i32 0, i32 0
  %readtmp8 = load ptr addrspace(5), ptr addrspace(5) %5, align 8
  %calltmp9 = call void @free(ptr addrspace(5) %readtmp8)
  %readtmp10 = load ptr addrspace(5), ptr %sb, align 8
  %6 = getelementptr inbounds %SpriteBatch, ptr addrspace(5) %readtmp10, i32 0, i32 0
  %readtmp11 = load ptr addrspace(5), ptr addrspace(5) %6, align 8
  %calltmp12 = call void @free(ptr addrspace(5) %readtmp11)
  ret void
  %calltmp13 = call void @SpriteBatch.deinit_0(ptr %sb)
  %readtmp14 = load ptr addrspace(5), ptr %ctx, align 8
}

define void @GFXContext.free_0(ptr addrspace(5) %0) {
entry:
  %calltmp = call void @free(ptr addrspace(5) %0)
  ret void
  %calltmp1 = call void @GFXContext.free_0(ptr addrspace(5) %readtmp14)
  ret i32 0
}
