Shader "Custom/Translucent" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Power("Power", Range(0,100)) = 0.0
		_Distortion("Distortion", Range(0,100)) = 0.0
		_Ambient("Ambient", Range(0,100)) = 0.0
		_Scale("Scale", Range(0,100)) = 0.0
		_LocalThickness("Thickness", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		LOD 200
		
		Cull Front

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf StandardTranslucent fullforwardshadows alpha
		#pragma target 3.0

			sampler2D _MainTex;
	sampler2D _LocalThickness;

		struct Input {
			float2 uv_MainTex;

		};

		half _Power;
		half _Distortion;
		half _Ambient;
		half _Scale;
		fixed4 _Color;

		#include "UnityPBSLighting.cginc"
		inline fixed4 LightingStandardTranslucent(SurfaceOutputStandard s, fixed3 viewDir, UnityGI gi)
		{
			// Original colour
			fixed4 pbr = LightingStandard(s, viewDir, gi);


			// --- Translucency ---
			float3 L = gi.light.dir;
			float3 V = viewDir;
			float3 N = s.Normal;

			float3 H = normalize(L + N * _Distortion);
			float VdotH = pow(saturate(dot(V, -H)), _Power) * _Scale;

			// Final add
			pbr.rgb = pbr.rgb + gi.light.color;
			return pbr;
		}

		void LightingStandardTranslucent_GI(SurfaceOutputStandard s, UnityGIInput data, inout UnityGI gi)
		{
			LightingStandard_GI(s, data, gi);
		}


		float thickness;
		void surf(Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex).rgba * _Color.rgba;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		
			thickness = tex2D(_LocalThickness, IN.uv_MainTex).r;
		}
		ENDCG
			
		Cull Back

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf StandardTranslucent fullforwardshadows alpha
			#pragma target 3.0

			sampler2D _MainTex;
		sampler2D _LocalThickness;

		struct Input {
			float2 uv_MainTex;

		};

		half _Power;
		half _Distortion;
		half _Ambient;
		half _Scale;
		fixed4 _Color;

#include "UnityPBSLighting.cginc"
		inline fixed4 LightingStandardTranslucent(SurfaceOutputStandard s, fixed3 viewDir, UnityGI gi)
		{
			// Original colour
			fixed4 pbr = LightingStandard(s, viewDir, gi);


			// --- Translucency ---
			float3 L = gi.light.dir;
			float3 V = viewDir;
			float3 N = s.Normal;

			float3 H = normalize(L + N * _Distortion);
			float VdotH = pow(saturate(dot(V, -H)), _Power) * _Scale;

			// Final add
			pbr.rgb = pbr.rgb + gi.light.color;
			return pbr;
		}

		void LightingStandardTranslucent_GI(SurfaceOutputStandard s, UnityGIInput data, inout UnityGI gi)
		{
			LightingStandard_GI(s, data, gi);
		}

		void vert(inout appdata_full v) {
			v.normal *= -1;
		}

		float thickness;
		void surf(Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex).rgba * _Color.rgba;
			o.Albedo = c.rgb;
			o.Alpha = c.a;

			thickness = tex2D(_LocalThickness, IN.uv_MainTex).r;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
