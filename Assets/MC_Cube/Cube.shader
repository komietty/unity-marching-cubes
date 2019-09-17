Shader "Custom/Cube"
{
	Properties { }
	SubShader
	{
		CGINCLUDE
		#include "../MarchingCube/Cginc/MarchingCubeHeader.cginc"
		#include "../MarchingCube/Cginc/DF_Primitive.cginc"
		#include "../MarchingCube/Cginc/DF_Utils.cginc"
		#include "../Packages/unity-gist/Cginc/SimplexNoise.cginc"
		float4 _Trans[3];
		float4 _Rots[3];

        float DistanceFunction(float3 p, float3 q)
		{
			float3 _q;
			q += snoise3D(float4(q, 1));
			_q = q - _Trans[0].xyz;

			_q = rotate(_q, _Rots[0].x, float3(1, 0, 0));
			_q = rotate(_q, _Rots[0].y, float3(0, 1, 0));
			_q = rotate(_q, _Rots[0].z, float3(0, 0, 1));
			float d1 = -box(_q, _Trans[0].w) + 0.5;

			_q = q - _Trans[1].xyz;
			_q = rotate(_q, _Rots[1].x, float3(1, 0, 0));
			_q = rotate(_q, _Rots[1].y, float3(0, 1, 0));
			_q = rotate(_q, _Rots[1].z, float3(0, 0, 1));
			float d2 = -box(_q, _Trans[1].w) + 0.5;

			_q = q - _Trans[2].xyz;
			_q = rotate(_q, _Rots[2].x, float3(1, 0, 0));
			_q = rotate(_q, _Rots[2].y, float3(0, 1, 0));
			_q = rotate(_q, _Rots[2].z, float3(0, 0, 1));
			float d3 = -box(_q, _Trans[2].w) + 0.5;

			float o1 = smoothMax(d1, d2, 9);
			float o2 = smoothMax(o1, d3, 9);
			return o2;
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
				float3 wCol = (abs(i.worldPos.z) < 1.37)? _WireframeColor : float3(1, 0, 0);
            	return float4(lerp(wCol, col.rgb, minBary).xyz, 1.0);
            }
			ENDCG
		}
	}
}
