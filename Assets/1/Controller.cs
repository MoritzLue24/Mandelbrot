using UnityEngine;

public class Controller : MonoBehaviour {
    
    public Material material;
    public Vector2 position;
    public float scale;
    public float smoothFactor;
    public float factor;

    Vector2 smoothPosition;
    float smoothScale;

    void UpdateShader() {
        smoothPosition = Vector2.Lerp(smoothPosition, position, smoothFactor);
        smoothScale = Mathf.Lerp(smoothScale, scale, smoothFactor);

        float aspect = (float)Screen.width / (float)Screen.height;
        float scaleX = smoothScale;
        float scaleY = smoothScale;

        if (aspect > 1)
            scaleY /= aspect;
        else
            scaleX *= aspect;

        material.SetVector("_Area", new Vector4(smoothPosition.x, smoothPosition.y, scaleX, scaleY));
        material.SetFloat("_Factor", factor);
    }

    void HandleInputs() {
        if (Input.GetKey(KeyCode.KeypadPlus))
            scale *= .99f;
        if (Input.GetKey(KeyCode.KeypadMinus))
            scale *= 1.01f;
        
        if (Input.GetKey(KeyCode.A))
            position.x -= .01f * scale;
        if (Input.GetKey(KeyCode.D))
            position.x += .01f * scale;

        if (Input.GetKey(KeyCode.S))
            position.y -= .01f * scale;
        if (Input.GetKey(KeyCode.W))
            position.y += .01f * scale;
    }

    void FixedUpdate() {
        HandleInputs();
        UpdateShader();
    }
}