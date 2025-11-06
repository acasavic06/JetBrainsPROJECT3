#define M_PI 3.14159265358979323846f

export void solve_newton_fractal(
    uniform int W,
    uniform int H,
    uniform int maxIter,
    uniform float delta,
    uniform int n,
    uniform int outputRootIndex[], // output for root index for each pixel
    uniform int outputIterCount[] // output for iteration count per pixel
) {
    // Precompute real and imaginary parts of all n roots
    uniform float roots_re[16];
    uniform float roots_im[16];
    for (uniform int i = 0; i < n; i++) {
        uniform float angle = 2.0f * M_PI * i / n;
        roots_re[i] = cos(angle);
        roots_im[i] = sin(angle);
    }

    // Define the domain in the complex plane
    uniform float xmin = -W / n / 10;
    uniform float xmax =  W / n / 10;
    uniform float ymin = -H / n / 10;
    uniform float ymax =  H / n / 10;

    // Precalculate constants for better perfomance
    uniform float invW = 1.0f / W;
    uniform float invH = 1.0f / H;
    uniform float dx = (xmax - xmin) * invW;
    uniform float dy = (ymax - ymin) * invH;

    // Parallel loop over all pixels
    foreach (idx = 0 ... W * H) {
        int x = idx % W;
        int y = idx / W;

        float zr = xmin + (x + 0.5f) * dx;
        float zi = ymin + (y + 0.5f) * dy;

        int iter = 0;
        int root_index = -1;

        // Newton iteration
        for (iter = 0; iter < maxIter; iter++) {
            float r = sqrt(zr * zr + zi * zi);
            r=max(r,1e-8f);
            float theta = atan2(zi, zr);

            // Calculate f(z)=z^n - 1 and f'(z)
            float r_pow_n1 = 1.0f;
            for (int i = 1; i < n; i++) r_pow_n1 *= r;
            float r_pow_n = r_pow_n1 * r;

            float f_r  = r_pow_n  * cos(n * theta) - 1.0f;
            float f_i  = r_pow_n  * sin(n * theta);
            float fp_r = n * r_pow_n1 * cos((n - 1) * theta);
            float fp_i = n * r_pow_n1 * sin((n - 1) * theta);

            float squared_modul = fp_r * fp_r + fp_i * fp_i;
            if (squared_modul < 1e-16f)
                break;

            // Newton step
            float t_r = (f_r * fp_r + f_i * fp_i) / squared_modul;
            float t_i = (f_i * fp_r - f_r * fp_i) / squared_modul;

            float zr_next = zr - t_r;
            float zi_next = zi - t_i;

            // Check if we are close to any root
            bool near = false;
            for (int k = 0; k < n; k++) {
                float dr = zr_next - roots_re[k];
                float di = zi_next - roots_im[k];
                if (dr * dr + di * di < delta * delta) {
                    root_index = k;
                    near = true;
                    break;
                }
            }

            zr = zr_next;
            zi = zi_next;

            if (near)
                break;
        }

        // save the results
        outputRootIndex[idx] = root_index;
        outputIterCount[idx] = iter;
    }
}
