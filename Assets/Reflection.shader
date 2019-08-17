Shader "Custom/Reflection"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "bump" {}
		_MaskMap("MaskMap", 2D) = "white" {}
		_Cube ("Cubemap", Cube) = "" {}
		_Intensity ("Reflection Intensity", Range(0,1)) = 0.5
		_Color ("Reflection Color", color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _MaskMap;
		samplerCUBE _Cube;
		float _Intensity;
		fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
			float3 worldRefl;
			// 버텍스 월드 노멀 데이터와 탄젠트 노멀 데이터를 같이 사용하면 에러가 발생한다.
			// INTERNAL_DATA 키워드는 버텍스 노멀 데이터를 픽셀 노멀 데이터로 변환한다.
			INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);			
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			float4 re = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal)) * _Color;
			fixed4 m = tex2D(_MaskMap, IN.uv_MainTex);

			o.Albedo = c.rgb * (1-m.r);
			o.Emission = re.rgb * m.r;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
