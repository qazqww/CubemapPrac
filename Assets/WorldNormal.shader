Shader "Custom/WorldNormal"
{
    Properties
    {
        _BumpMap ("Albedo (RGB)", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
			float3 worldNormal;
			INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			float3 WorldNormal = WorldNormalVector(IN, o.Normal);			
			o.Emission = WorldNormal;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
