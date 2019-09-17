#ifndef distfunc_letters
#define distfunc_letters
#include "DF_Utils.cginc"
#include "Easing.cginc"
#include "DF_Primitive.cginc"

#define LP float3(-0.25, 0, 0)
#define RP float3( 0.25, 0, 0)
#define TP float3( 0,  0.4, 0)
#define MP float3( 0,    0, 0)
#define BP float3( 0, -0.4, 0) // bottom position
#define VS float3(0.15, 0.9, 0.15) // vertical size
#define HS float3(0.6, 0.15, 0.15) // horizontal size
#define XA float3(1, 0, 0) // x axis
#define YA float3(0, 1, 0) // y axis
#define ZA float3(0, 0, 1) // z axis

float v_line_L(float3 p) { return -box(p - LP, VS); }
float v_line_R(float3 p) { return -box(p - RP, VS); }
float h_line_T(float3 p) { return -box(p - TP, HS); }
float h_line_M(float3 p) { return -box(p - MP, HS); }
float h_line_B(float3 p) { return -box(p - BP, HS); }

float capitalA(float3 p) {
    float3 size = float3(0.15, 0.95, 0.15);
    float1 s1 = -box(rotate(p,  PI * 0.87, ZA) + float3(-0.15, -0.1, 0), size);
    float1 s2 = -box(rotate(p, -PI * 0.87, ZA) + float3(0.15, -0.1, 0), size);
    float1 s3 = -box(p + float3(0, 0.2, 0), float3(0.4, 0.1, 0.03));
    return max(s3, max(s1, s2));
}

float capitalB(float3 p) {
    float s1 = -box(rotate(p - float3(0, -0.03, 0), -PI * 0.01, ZA) - LP, VS);
    bool  f = p.x > -0.3;
    float s2 = f ? -link(rotate(p - float3(-0.15,  0.2, 0), PI * 0.5, ZA), 0.3, 0.2, 0.07) : -100;
    float s3 = f ? -link(rotate(p - float3(-0.15, -0.2, 0), PI * 0.5, ZA), 0.3, 0.2, 0.07) : -100;
    return max(max(s1, s2), s3);
}

float capitalE(float3 p) {
    float s1 = v_line_L(rotate(p, -PI * 0.01, ZA));
    float s2 = -box(p - TP - float3(0.01, 0, 0), HS);
    float s3 = -box(p - MP, float3(0.4, HS.y, HS.z * 0.2));
    float s4 = h_line_B(p);
    return max(max(s1, s2), max(s3, s4));
}

float capitalD(float3 p) {
    float s1 = v_line_L(rotate(p, -PI * 0.01, ZA));
    float3 q = p - float3(-0.3, 0, 0);
    float s2 = p.x > -0.35 ? -link(rotate(q, PI * 0.5, ZA), 0.3, 0.4, 0.07) : -100;
    return max(s1, s2);
}

float capitalP(float3 p) {
    float s1 = -box(rotate(p - float3(0, -0.03, 0), -PI * 0.01, ZA) - LP, float3(VS.x, VS.y * 1.05, VS.z));
    float s2 = p.x > -0.3 ? -link(rotate(p - float3(-0.15, 0.2, 0), PI * 0.5, ZA), 0.3, 0.2, 0.07) : -100;
    return max(s1, s2);
}

float capitalR(float3 p) {
    float s1 = -box(rotate(p - float3(0, -0.03, 0), -PI * 0.01, ZA) - LP, float3(VS.x * 0.9, VS.y * 1.05, VS.z * 0.9));
    float s2 = p.x > -0.3 ? -link(rotate(p - float3(-0.15, 0.2, 0), PI * 0.5, ZA), 0.3, 0.2, 0.07) : -100;
    float s3 = -box(rotate(p, -PI * 0.87, ZA) + float3(0.1, -0.35, 0), float3(0.15, 0.5, 0.15));
    return max(max(s1, s2), s3);
}

float capitalL(float3 p) {
    float s1 = v_line_L(p);
    float s2 = h_line_B(p);
    return max(s1, s2);
}

float Lerp(float v1, float v2, float l) {
    float v3 = smoothMax(v1, v2, 8);
    return (l < 0.5) ?  lerp(v1, v3, EaseInOutQuint(l * 2)) : lerp(v3, v2, EaseInOutQuint(l * 2 - 1));
}

#endif