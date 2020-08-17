# Lab 1 - IoT Devices (Or, What the Heck Does IoT *Mean*?)
**TLDR:** Use a Raspberry Pi to create the internal system for an object detecting car to avoid collision. Once you're done, in your own words you should be able to describe what is a VN in a car, how it is an IoT system, conceptually understand how that abstracts to IoT networks in general.

**Deliverables:** 
* A report that describes your experience in this lab and answers the following questions (tagged with /report) regarding the components of the car and the system itself
* The python package which contains the image recognition (IR), path creation (PC) and Actuator Controller (AC) acomponents
    * The IR component must have a `REPLACE_FUNCTION_NAME()` method
    * The PC component must have a `REPLACE_FUNCITON_NAME()` method
    * The AC component must have a `REPLACE_FUNCITON_NAME()` method
    
## 1. Introduction and Theoretical Motivation
* "Cloud computing" is a buzzword for distributed systems of on demand processing and memory storage.
* In the same manner, "Internet of things" is a buzzword. What do you think IoT means? 
* This lab will walk you through the development of an **obstacle avoidance and lane departure mitigation** system, like one seen on the 2019 Honda Civic. By creating this **Vehicular Network (VN) **, you will have implemented an IoT System. 
* Ideally, this process will provide you with the tools to describe an IoT system in layman terms as well as understand intuitively what concepts the buzzword "IoT" actually represents.
### What is an internal Vehicular Network (VN)?

In short, a VN is a system within the a car that can add automated functionality to a vehicle.
Some features of a VN can include:
* Maintain an internal temperature of 70°F
* Set Cruise control
* **Detect and avoid objects** - This is the focus of our lab

Within a VN, there will be the following components:
* A Set of Inputs
* A Set of Outputs
* A Set of I/O processing components 
* A Communication Protocal between the components

Special emphasis should be placed on the last two points. If a VN was simply the I/O components, then there wouldn't be a functional automated VN system. The I/O components need to be able to communicate with each other (e.g through wired ethernet) and there should be at least one "computer" to process inputs and decide on the outputs.

## What are we doing in this Lab?
We will be implement and apply a VN to a programmable Raspberry Pi and car system so that it can **avoid obstacles and stay on a lane**. This can be broken into three main problem statements.

**1. A Computer Vision System**
* Given a forward facing camera, indicate when an object (like a human) is near or on the path a car is traversing.

**2. An Obstacle Avoidance System**
* Given a signal that there is an(are) object(s) detected on the car's current path towards a pre-set destination, construct and update the path so that it would avoid colliding with the object(s)

**3. An Actuation System**
* Actuators provide control of a mechanical system.
* Given a path towards a destination, control the motors of a car so that it can navigate that path as instructed (with minimal deviation)

 Just like in industry, a prototype must precede the real thing. Even if you were to work for a company like Honda, you would first start with a simplified and (relatively cheaper) system like this.

## What do we need and how do we get setup?
**Hardware (~$200-$240 USD)** - In order to get started on this lab, you will have to purchase/aquire the following material:
* Raspberry Pi
    * Raspberry Pi 4 (4 GB RAM) 
    * 64 GB microSD (32 GB should also be fine)
    * Pi camera module V2 
    * SD Reader on your computer (to download the OS image)
        * Some laptops/computers don't have this anymore, you'll need an adapter for your specific machine
* Automobile
    * Car Chassis Kit
    * 18650 Batteries
* Connecting your Pi to a keyboard, mouse, and monitor:
    * Option 1: Connect the Pi to your Laptop
        * Example tutorial: https://spin.atomicobject.com/2019/06/09/raspberry-pi-laptop-display/
        * This is more technical but will not require any extra components
    * Option 2: Connect an external mouse, keyboard, and monitor through the Pi's USB and HDMI ports
        * Assuming you have all the components, this is much easier. If you don't have them, you'll have to decide if the the effort saved is worth the additional purchases.

**Software Setup**

This setup is relatively complex with a steep learning curve if you're unfamiliar with Raspberry Pi's, linux-based OS, installing Tensorflow or python packages in general.  

While it is important to learn how to confure all of this, many of the steps can be non intuitive when doing this for the first time. With that in mind, this is the setup stage for a reason. **PLEASE GET STARTED EARLY AND ASK FOR HELP IN THE DISCORD IF YOU GET STUCK IN THIS STAGE** The lab work doesn't *really* start until after all of these components have been completed.

* Raspbian OS
    * Use the SD card to transfer an image from your computer to the Pi
    * https://www.pibakery.org/ is a good source to configure an image with WiFi and any other necessary settings
* Python modules (open the Pi terminal to install them with `pip`)
    * The `picamera` module
        * `pip install --user picamera[array]`
        *  This package enables the Pi to process the camera feed through numpy in real time
        *  The `raspistill` commmand can be used to test the camera by taking a still picture
        *  Make sure you've connected the Pi Camera to the Pi
    * The `OpenCV` module
        * `sudo apt update`
        * `sudo apt install libatlas3-base libsz2 libharfbuzz0b libtiff5 libjasper1 libilmbase12 libopenexr22 libilmbase12 libgstreamer1.0-0 libavcodec57 libavformat57 libavutil55 libswscale4 libqtgui4 libqt4-test libqtcore4 libwebp6 libhdf5-100`
        * `wget https://bootstrap.pypa.io/get-pip.py`
        * `python3 get-pip.py`
        * `sudo pip3 install opencv-contrib-python`
            * #ALTERNATIVE IF THIS FAILS: # `sudo pip3 install opencv-contrib-python -i https://www.piwheels.org/simple`
    * The `tensorflow` module (The TF team recently added Pi support!)
        * `sudo apt install libatlas-base-dev`
        * `sudo pip3 install tensorflow`
        * If you're unfamiliar with TF or Google's object detection API, you should at least examine to the following references before continuing further:
            * How to use the object detection API: https://github.com/GoogleCloudPlatform/tensorflow-object-detection-example
                * If you are using newer Tensorflow versions, note that some APIs mentioned in here might be deprecated or their signatures might have changed. In this case, please use the new version of these APIs to replace them.
            * The object detection API: https://github.com/tensorflow/models/tree/master/research/object_detection


"For packages on Raspbian, the versions we tested to work are: 
Raspbian 9.0 (Stretch) full version with Python 3.5.3 installed.
TensorFlow 1.14 with Protobuf 3.9.1
OpenCV-Python 3.4.4"  - From the original Lab 1 document.

## 1. A Computer Vision System
Assuming the software setup is completed, the Raspberry Pi now has access to the camera feed through `picamera` and CNN models through `tensorflow`. With those features in place, we can now write an object detection application. There are many approaches we can choose, creativity and implementation of this part is left to the reader/student.

* **Problem Statement** - Create a python package using the camera feed and TF CNNs to create a real time (~1 frame per second (FPS)) object detection system.
    * **NOTE** - Pi's, while crafty, don't have much computation power. 25fps is not realistic given the machine's specs and the Lab's time constraints

* **Reflection Questions for the Report** /report
    * Quantized, low precision models, leverage 8 bit integers to replace floating point operations, they provide good performance for the Pi as well as other resource-constrained devices. **Why would this be true?**
    * Would hardware acceleration help in image processing? Have the packages mentioned above leveraged it?
    * If not, how could you properly leverage hardware acceleration?
    * Would multithreading help increase (or hurt) the performance of your program?
    * How would you choose the trade-off between frame rate and detection accuracy?

## 2. An Obstacle Avoidance System

* **Problem Statement** - TBD

* **Reflection Questions for the Report** /report
    * TBD

## 3. An Actuation System

* **Problem Statement** - TBD

* **Reflection Questions for the Report** /report
    * TBD

### Disclaimer
This write up was based off of the WIP Lab 1 for the real IoT course offered in the Fall 2020 term at UIUC: https://docs.google.com/document/d/1rH2qgqDB0XeqtBAclkbGU9wsZ4SfoHY8EVzEblF0TbI/edit?usp=sharing. (I am not the owner of this document)

While some revision was original, by and large the credit for this lab and its structure lay with Matt Caesar, his IoT TAs, and anyone else on his team contributing to the development for this course.
