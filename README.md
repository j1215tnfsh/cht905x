# cht905x
Automated docker build for CHT using 905x chip and AOSP 7.1

## Docker build
```
docker build -t cht905x .
```

## Build the source code
```
docker run --rm -it \
--mount type=bind,source=/home/johnnyli/Work/CHT_905x/source,target=/src \
--mount type=bind,source=/home/johnnyli/Work/CHT_905x/out,target=/src/out \
--mount type=bind,source=/opt/aml_toolchains,target=/opt/aml_toolchains \
cht905x [[build] [slow] | source]
```

## Debugging
```
docker run [some-options] cht905x [root,user]
```
