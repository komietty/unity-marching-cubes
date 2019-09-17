using UnityEngine;

public class MarchingCubeDrawMesh : MonoBehaviour {

    public enum AspectFitting { Max, Min }
    public Material mat;
    public Vector3Int segments;
    public int scale;
    public AspectFitting fitting = AspectFitting.Min;
    int vertexMax = 0;
    Mesh mesh;
    Vector3 renderScale;
    public Vector3 aspect { get; private set; }
    MarchingCubeDefines mcDefines = null;

    void Initialize() {
        mesh = new Mesh();
        vertexMax = segments.x * segments.y * segments.z;
        if(fitting == AspectFitting.Min) aspect = (Vector3)segments / Mathf.Min(Mathf.Min(segments.x, segments.y), segments.z);
        else                             aspect = (Vector3)segments / Mathf.Max(Mathf.Max(segments.x, segments.y), segments.z);
        renderScale = new Vector3(1f / segments.x, 1f / segments.y, 1f / segments.z);
        mcDefines = new MarchingCubeDefines();
        transform.localScale = scale * aspect; 
        CreateMesh();
    }

    void CreateMesh() {
        var vertices = new Vector3[vertexMax];
        var indices = new int[vertexMax];
        for (int j = 0; j < vertexMax; j++) {
            vertices[j].x = j % segments.x;
            vertices[j].y = (j / segments.x) % segments.y;
            vertices[j].z = (j / (segments.x * segments.y)) % segments.z;
            indices[j] = j;
        }
        if (vertexMax > 65535) mesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32;
        mesh.vertices = vertices;
        mesh.SetIndices(indices, MeshTopology.Points, 0);
        mesh.bounds = new Bounds(transform.position, Vector3.one);
    }

    void RenderMesh() {
        mat.SetVector("_SegmentNum", (Vector3)segments);
        mat.SetVector("_Scale", renderScale);
        mat.SetVector("_Aspect", aspect);
        mat.SetMatrix("_Matrix", Matrix4x4.TRS(transform.position, transform.rotation, transform.localScale));
        mat.SetBuffer("vertexOffset", mcDefines.vertexOffsetBuffer);
        mat.SetBuffer("cubeEdgeFlags", mcDefines.cubeEdgeFlagsBuffer);
        mat.SetBuffer("edgeConnection", mcDefines.edgeConnectionBuffer);
        mat.SetBuffer("edgeDirection", mcDefines.edgeDirectionBuffer);
        mat.SetBuffer("triangleConnectionTable", mcDefines.triangleConnectionTableBuffer);
        Graphics.DrawMesh(mesh, Matrix4x4.identity, mat, 0);
    }

    void Start() {
        Initialize();
    }

    void Update() {
        if (mat != null) RenderMesh();
    }

    void OnDestroy() {
        mcDefines.ReleaseBuffer();
        Destroy(mesh);
    }

    void OnDrawGizmos() {
        Gizmos.color = Color.red;
        Gizmos.DrawWireCube(Vector3.zero, scale * aspect);
    }
}
