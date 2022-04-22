# Edge Impulse Example: standalone inferencing (Silabs Gecko SDK 4.x)

This builds and runs an exported impulse locally on your machine. See the documentation at Deploy your model as a SLCC component.

## Basic steps

1. Export SLCC component form Studio
1. Extract content of the exported component into `ei-model` directory.
1. Build project

### Building from command line

1. Install [SLC CLI Tools](https://www.silabs.com/documents/public/user-guides/ug520-software-project-generation-configuration-with-slc-cli.pdf)
1. Install [Simplicity Commander](https://community.silabs.com/s/article/simplicity-commander?language=en_US)
1. Generate Makefile for your board (for example BRD4166A - Thunderboard Sense 2)

    ```
    slc generate inference-example.slcp -cp -np --toolchain=gcc --output-type=makefile --with=brd4166a
    ```

1. Compile

    ```
    make -f inference-example.Makefile -j
    ```

1. Flash

    ```
    commander flash build/debug/inference-example.hex
    ```

### Building using Simplicity Studio 5

1. Import project into Simplicity Studio
1. Select target board on `Reconstruct Build Configuration` stage
1. After importing, remove `ei-model` form `Project Explorer`
1. Open `inference-example.slcp` and click `Force Generation` button
1. Build and flash project as usual

 ## License

 [Appache License v2.0](https://www.apache.org/licenses/LICENSE-2.0)
 