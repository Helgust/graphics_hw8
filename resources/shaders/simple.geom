#version 450
layout (triangles) in;
layout (triangle_strip, max_vertices = 6) out;

layout(push_constant) uniform params_t
{
    mat4 mProjView;
    mat4 mModel;
    float mTime;
} params;

layout (location = 0 ) in VS_OUT
{
    vec3 wPos;
    vec3 wNorm;
    vec3 wTangent;
    vec2 texCoord;

} vIn[];

const float MAGNITUDE = 0.1f;

vec4 GetNormal()
{
   vec3 a = vec3(vIn[1].wPos) - vec3(vIn[0].wPos);
   vec3 b = vec3(vIn[2].wPos) - vec3(vIn[1].wPos);
   return vec4(normalize(cross(a, b)), 0.f);
}  

void main()
{
    vec3 A = vIn[0].wPos;
    vec3 B = vIn[1].wPos;
    vec3 C = vIn[2].wPos;

    vec4 center = vec4((A + B + C) / 3, 1.f);
    vec4 centerAB = vec4((A + B) / 2, 1.f);
    vec4 centerAC = vec4((A + C) / 2, 1.f);
    vec4 centerBC = vec4((B + C) / 2, 1.f);

    float coef = cos(params.mTime);
    float coef2 = sin(params.mTime);

    gl_Position = params.mProjView * (vec4(A,1.f));
    EmitVertex();

    gl_Position = params.mProjView * (centerAB + 0.1 * coef2 + GetNormal() * coef * MAGNITUDE);
    EmitVertex();

    gl_Position = params.mProjView * (vec4(B,1.f));
    EmitVertex();

    EndPrimitive();

    gl_Position = params.mProjView * (vec4(A,1.f));
    EmitVertex();

    gl_Position = params.mProjView * (centerAC + GetNormal() * coef * MAGNITUDE);
    EmitVertex();

    gl_Position = params.mProjView * (vec4(C,1.f));
    EmitVertex();

    EndPrimitive();
}   