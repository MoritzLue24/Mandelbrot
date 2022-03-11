Shader "Mandelbrot/Mandelbrot"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Area("Area", vector) = (0, 0, 4, 4)	// x, y = position; z, w = size;
        _Factor("Factor", float) = 2
        _Iterations("Iterations", float) = 64
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			float4 _Area;
            float _Factor;
            float _Iterations;

            fixed4 frag (v2f i) : SV_Target
            {
                float2 c = _Area.xy + (i.uv -.5) * _Area.zw;
				float2 z;

                float m = 0;
				const float r = 5;

				for (int n = 0; n < _Iterations; n += 1) {
					z = float2(z.x*z.x - z.y*z.y, _Factor*z.x*z.y) + c;
					if (dot(z, z) < (r*r - 1))
                        m++;
                    z = clamp(z, -r, r);
				}

                if (m == floor(_Iterations))
                    return 0;
                else
                    return float4(sin(m/4), sin(m/5), sin(m/7), 1) / 4 + 0.75;
            }
            ENDCG
        }
    }
}
