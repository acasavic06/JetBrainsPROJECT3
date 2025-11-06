#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#include <iostream>
#include <vector>
#include <array>
#include "analyzing_ispc.h"

using namespace std;

int main() {
    int W = 800, H = 800, maxIter = 50;
    float delta = 1e-3f;

    int n; scanf("%d", &n);
    if (n <= 0) {
        cout << "The number of roots must be greater than zero\n";
        return 1;
    }

    vector<int> rootIndex(W * H);
    vector<int> iterCount(W * H);
    vector<unsigned char> image(W * H * 3);

    // ISPC FUNCTION
    ispc::solve_newton_fractal(W, H, maxIter, delta, n, rootIndex.data(), iterCount.data());

    vector<array<unsigned char, 3>> colors(n);
    if (n == 1) { // only red
        colors[0] = {255, 0, 0};
    }
    else if (n == 2) { // red and blue
        colors[0] = {255, 0, 0};
        colors[1] = {0, 0, 255};
    }
    else { //red, blue, green and colour from red to blue
        colors[0] = {255, 0, 0};
        colors[1] = {0, 255, 0};
        colors[2] = {0, 0, 255};

        for (int i = 0; i < n - 3; i++) {
            float r = 255.0f * (i + 1) / (n - 3);
            float b = 255.0f * (n - i - 2) / (n - 3);
            float g = 128.0f;

            colors[i + 3] = {
                (unsigned char)r,
                (unsigned char)g,
                (unsigned char)b
            };
        }
    }

    for (int i = 0; i < W * H; i++) {
        int root = rootIndex[i];
        int iter = iterCount[i];

        float t = (float)iter / maxIter;

        unsigned char r = 0, g = 0, b = 0;
        if (root >= 0 && root < n) {
            r = (unsigned char)(colors[root][0] * (1 - t));
            g = (unsigned char)(colors[root][1] * (1 - t));
            b = (unsigned char)(colors[root][2] * (1 - t));
        }

        image[i * 3 + 0] = r;
        image[i * 3 + 1] = g;
        image[i * 3 + 2] = b;
    }

    stbi_write_png("newton_fractal.png", W, H, 3, image.data(), W * 3);
    cout << "Fractal saved as newton_fractal.png";

    return 0;
}

