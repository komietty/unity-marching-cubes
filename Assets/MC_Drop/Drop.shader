Shader "Custom/Drop"
{
	Properties { }
	SubShader
	{
		CGINCLUDE
		#include "../MarchingCube/Cginc/MarchingCubeHeader.cginc"
		#include "../MarchingCube/Cginc/DF_Letters.cginc"
		float4 _Params[2];
	    float4 _LetterLerp;
		int _Pattern;

        float DistanceFunction(float3 p, float3 q)
		{
			float result = 0;

			// drops
			float s01 = -sphere(q - _Params[0].xyz, _Params[0].w);
			float s02 = -sphere(q - _Params[1].xyz, _Params[1].w);
			float drp = smoothMax(s01, s02, 20);

			// env
			float3 pos = float3(0, 0.34, 0);
			float4 nrm = float4(0, 1, 0, 0);
			float env = max(-plane(p - pos, -nrm), -plane(p + pos, nrm));

			// letters
			float3 rot = float3(-sin(_Time.y) * 2, cos(_Time.z), sin(_Time.z));
			float1 rad = PI * 0.87;
			float3 oft = float3(.5, 0, 0);
			float3 q1 = rotate(q + oft * 3, rad, rot);
			float3 q2 = rotate(q + oft    , rad, rot);
			float3 q3 = rotate(q - oft    , rad, rot);
			float3 q4 = rotate(q - oft * 3, rad, rot);
			bool f = _Pattern == 0;

			float ltr1 = Lerp(    capitalB(q1)               , -cross(q1), _LetterLerp.x);
			float ltr2 = Lerp(    capitalE(q2),                -cross(q2), _LetterLerp.y);
			float ltr3 = Lerp(f ? capitalE(q3) : capitalA(q3), -cross(q3), _LetterLerp.z);
			float ltr4 = Lerp(    capitalR(q4),                -cross(q4), _LetterLerp.w);

			float ltr = max(max(ltr1, ltr2), max(ltr3, ltr4));

			result = smoothMax(env, smoothMax(ltr, drp, 10), 20);
			return result + 0.5;
        };
        
        #include "../MarchingCube/Cginc/MarchingCubeFooterWireframe.cginc"
		ENDCG

		Pass
		{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma target 5.0
			#pragma vertex vert
			#pragma geometry geom_wire
			#pragma fragment frag_wire_alt

            float4 frag_wire_alt(g2f_wire i) : SV_Target
            {
            	float4 col = float4(_DiffuseColor.rgb, 1);
            	float3 barys;
            	barys.xy = i.barycentricCoordinates;
            	barys.z = 1 - barys.x - barys.y;
            	float3 deltas = fwidth(barys);
            	float3 smoothing = deltas * _WireframeSmoothing;
            	float3 thickness = deltas * _WireframeThickness;
            	barys = smoothstep(thickness, thickness + smoothing, barys);
            	float minBary = min(barys.x, min(barys.y, barys.z));
            	return float4(lerp(_WireframeColor, col.rgb, minBary).xyz, 1.0);
            }
			ENDCG
		}
	}
}
