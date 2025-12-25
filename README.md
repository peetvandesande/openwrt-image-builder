Script to build a custom OpenWRT image, containing current packages and configuration files to make for easier updates.

## Verify
- version

## Run
```
./prepare.sh
```

Then, inside the container:
```
./setup.sh
./build.sh
exit
```

Voila, files in the `bin` directory
