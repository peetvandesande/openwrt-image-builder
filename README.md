Script to build a custom OpenWRT image, containing my current packages and configuration files to make for easier updates.

## Verify
- version
- list of files (hint: Look in the Backup section of Luci for the default list of files)

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
