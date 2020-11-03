FROM node:10

ENV NDK_VERSION r17c
ENV SDK_VERSION sdk-tools-linux-3859397.zip
ENV ANDROID_HOME /build/android-sdk
ENV ANDROID_NDK /build/android-ndk
ENV ANDROID_BUILD_TOOLS_VERSION 28.0.3
ENV ANDROID_PLATFORM_VERSION 28
ENV PYTHON_VERSION 3.5.2

WORKDIR /build

RUN apt-get update && \
  apt-get install -y \
    coreutils \
    realpath \
    curl \
    libssl-dev \
    git \
    subversion \
    python-dev \
    ruby \
    gperf \
    python3 \
    python3-dev \
    openjdk-8-jdk

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/${SDK_VERSION} https://dl.google.com/android/repository/${SDK_VERSION} && \
  mkdir -p ${ANDROID_HOME} && \
  unzip -q /tmp/${SDK_VERSION} -d ${ANDROID_HOME} && \
  rm /tmp/${SDK_VERSION}

ENV PATH ${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

RUN mkdir ~/.android && echo '### User Sources for Android SDK Manager' > ~/.android/repositories.cfg

RUN yes | sdkmanager --licenses && sdkmanager --update

RUN sdkmanager \
  "tools" \
  "platform-tools" \
  "emulator" \
  "extras;android;m2repository" \
  "extras;google;m2repository" \
  "extras;google;google_play_services"

RUN sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"

RUN sdkmanager "platforms;android-${ANDROID_PLATFORM_VERSION}"

RUN mkdir /tmp/android-ndk-tmp && \
  cd /tmp/android-ndk-tmp && \
  wget -q https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux-x86_64.zip && \
  unzip -q android-ndk-${NDK_VERSION}-linux-x86_64.zip && \
  mv ./android-ndk-${NDK_VERSION} ${ANDROID_NDK} && \
  cd ${ANDROID_NDK} && \
  rm -rf /tmp/android-ndk-tmp

RUN sdkmanager "cmake;3.6.4111459"

COPY . .

RUN npm run clean

RUN npm run download

RUN npm run start

RUN tar cfz dist.tar.gz dist