FROM public.ecr.aws/ubuntu/ubuntu:22.04

ENV SD_HOME=/sd
WORKDIR $SD_HOME

RUN echo -e "Prepare runtime ..."
RUN \
  apt-get update && \
  apt install software-properties-common -y && \
  add-apt-repository ppa:deadsnakes/ppa -y && \
  apt install wget git build-essential net-tools libgl1 needrestart -y 
RUN pip install httpx==0.22.0 && pip install httpcore==0.14.7

RUN echo -e "Get stable-diffusion-webui ..."
RUN git clone https://github.com/TipTopBin/stable-diffusion-webui $SD_HOME/stable-diffusion-webui

RUN echo -e "Setup aws related extensions ..."
RUN git clone https://github.com/TipTopBin/stable-diffusion-aws-extension.git $SD_HOME/stable-diffusion-webui/extensions/stable-diffusion-aws-extension
RUN cd $SD_HOME/stable-diffusion-webui/extensions/stable-diffusion-aws-extension && ./r_pre-flight.sh -f

RUN echo -e "Get more extensions..."
RUN git clone https://github.com/TipTopBin/sd-webui-bilingual-localization $SD_HOME/stable-diffusion-webui/extensions/sd-webui-bilingual-localization
RUN git clone https://github.com/TipTopBin/stable-diffusion-webui-localization-zh_Hans $SD_HOME/stable-diffusion-webui/extensions/stable-diffusion-webui-localization-zh_Hans
RUN git clone https://github.com/TipTopBin/sd-webui-prompt-all-in-one $SD_HOME/stable-diffusion-webui/extensions/sd-webui-prompt-all-in-one
RUN git clone https://github.com/TipTopBin/stable-diffusion-webui-images-browser $SD_HOME/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser

EXPOSE 7860
ENV CLI_ARGS=""

ENTRYPOINT ["/bin/bash"]
CMD ["${SD_HOME}/stable-diffusion-webui/webui.sh --listen --port 7860 ${CLI_ARGS}"]