using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeUnit : MonoBehaviour {

    public float radius;
    public float speed;

    void Update() {
        var t = Time.time * speed;
        transform.position = new Vector3(Mathf.Cos(t), 0, Mathf.Sin(t)) * radius;
    }
}
