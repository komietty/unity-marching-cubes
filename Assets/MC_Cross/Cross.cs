using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Cross : MC_Base {
    [Header("Cross")]
    public Vector4 noise; // xyz: offset, w: strength
    Sequence bumpSeq;
    IEnumerator noiseOffsetCO;
    IEnumerator noiseStrengthCO;

    void Start() {
    }

    protected override void Update() {
//        if (randomRot) {
//            transform.rotation = Random.rotation;
//        }
//        else if (!freeze) {
//            var t = Time.time * rotSpeed;
//            pillers.transform.rotation = Quaternion.Euler(
//                Mathf.Sin(t) * 180,
//                0,
//                Mathf.Sin(Mathf.PerlinNoise(t, t)) * 180
//                );
//        }

        base.Update();
        noise.y += 0.05f;
        mat.SetVector("_Noise", noise);
    }

    public void SetNoiseStrength(float v) {
        bumpSeq.Kill();
        noise.w = v;
        noiseStrengthCO = SinNoiseStrengthCO();
        StartCoroutine(noiseStrengthCO);
    }


    public void SetRandomOffset() {
        if (noiseOffsetCO != null) StopCoroutine(noiseOffsetCO);
        noiseOffsetCO = SetRandomOffsetCO(20);
        StartCoroutine(noiseOffsetCO);
    }

    IEnumerator SetRandomOffsetCO(int loop) {
        for (var i = 0; i < loop; i++) {
            yield return new WaitForEndOfFrame();
            yield return new WaitForEndOfFrame();
            yield return new WaitForEndOfFrame();
            noise.x = Random.value * 100;
            noise.y = Random.value * 100;
            noise.z = Random.value * 100;
        }
    }

    IEnumerator SinNoiseStrengthCO() {
        while (true) {
            yield return new WaitForEndOfFrame();
            noise.w = 1f + Mathf.Sin(Time.deltaTime) * 0.25f;
        }
    }

    public void Bump(int loop) {
        bumpSeq.Kill();
        bumpSeq = DOTween.Sequence()
            .OnStart(() => noise.w = 0.3f)
            .Append(DOTween.To(() => noise.w, v => noise.w = v, 0f, 0.5f))
            .AppendInterval(0.8f)
            .SetLoops(loop, LoopType.Restart)
            .Play();
    }

     public void Reset() { }

}
