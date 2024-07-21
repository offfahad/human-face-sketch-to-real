# Face Sketch To Real (Sketch2Real): A Deep Learning-Powered Image Translation Application

## Introduction

Face Sketch To Real is a innovative image translation application which I developed for my final year project of BS Computer Science degree. All the project documentation and implementation of coding was made by a single developer, demonstrating comprehensive skills in machine learning, mobile application development, and backend integration.

## Project Overview

Face  Sketch To Real leverages state-of-the-art deep learning techniques, specifically Generative Adversarial Networks (GANs) and the Image-To-Image Translation Alogorithm, to translate hand-drawn human face sketches into realistic images. The application targets both mobile and web platforms, offering users an intuitive and interactive interface for creating lifelike portraits from rough sketches.

## Key Features

- **Advanced Deep Learning Model:** The heart of Sketch2Real is a deep learning model trained on a custom dataset which I made by myself comprising approximately 5000 samples of human face sketches and their corresponding real images and all human faces images are AI Generted (No person exists in real life). The model has been trained for over 10,000 epochs, ensuring exceptional accuracy and realism in image translation. More epochs more accurate results in this model arcitecture.

- **Cross-Platform Compatibility:** Built using the Flutter framework, Sketch2Real seamlessly caters to both mobile and web users, providing a consistent user experience across different devices and platforms.

- **Backend Infrastructure:** The project incorporates a robust RESTful API developed with Flask, enabling seamless communication between the application frontend and the deep learning model. This backend infrastructure ensures efficient handling of user requests and data transmission during the image translation process.

- **User-Friendly Interface:** Sketch2Real boasts an intuitive and visually appealing user interface, allowing users to effortlessly draw sketches, upload images, and interact with the application's various features. The interface supports real-time sketch editing, enabling users to refine their creations on the fly.

- **Authentication and Security:** Firebase authentication is integrated into Sketch2Real, ensuring secure user login and data privacy. User authentication mechanisms provide a seamless and secure experience for accessing the application's features and functionalities.

- **State Management and Performance Optimization:** The application leverages the GetX library for efficient state management, optimizing performance and resource utilization. This approach ensures smooth and responsive user interactions, even when handling complex image processing tasks.

## Quick Demo Video

https://github.com/offfahad/human-face-sketch-to-real/assets/19569802/c918c75e-8750-4794-bd94-22a40599edf0

## UI Of The Application

### Onboarding Screens
![Onboarding Screens](https://github.com/offfahad/Sketch2Real/assets/19569802/4cca1b84-f585-40f9-bbe8-0cb3f3b99f6f)

### Login and Sign Up Screens
![Login and Sign Up Screens](https://github.com/offfahad/Sketch2Real/assets/19569802/c4628f56-b374-42ff-8905-5cf7cf87d512)

### Forgot Password and OTP Screens
![Forgot Password and OTP Screens](https://github.com/offfahad/Sketch2Real/assets/19569802/0ed24d83-ed26-4826-a153-60b3cadfe1c5)

### Home Screen (Draw Sketch Like This And Make It Into Realistic Face Image)
![reuslts](https://github.com/offfahad/human-face-sketch-to-real/assets/19569802/0f308c24-3401-48bc-83eb-8c0d8d55bc3b)

### Edit Profile and Drawing Practice Screen
![WhatsApp Image 2024-05-10 at 21 25 48_11a8484b-imageonline co-merged](https://github.com/offfahad/Sketch2Real/assets/19569802/b061e606-4cf2-4dc1-916f-8d6fb4c4acc3)

# Model Training Results
## Test Dataset Images
![20epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/d2c7c5c3-b84f-4b6d-85d4-af038df273bf)
![100Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/93465c02-604f-4ddb-a95d-9ce4eb939482)
![200Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/d65c7f5b-70ec-4963-9b1e-077836743bab)
![300Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/3920b432-53f1-40f9-9142-43dff2e3fd6a)
![600Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/479b5a12-6570-411e-abb8-f546c85890eb)
![800Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/2b8de586-c910-491a-99cf-584db54c4879)
![1500Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/c63d6cc8-3d05-45b4-9293-73381bc75f4c)
![1800Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/efff6cb5-cacb-423e-8320-a0768a7fd7ac)
![2500Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/5e80456d-be76-40f7-954d-9b47cb03eeaa)
![3000Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/4a23497b-e50b-49eb-85fb-6ec7852b1bde)
![3500Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/47118745-50d0-44f1-908c-6db48103f4dd)
![4500Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/2f649eec-1617-485f-a599-84a701f91385)
![5000Epochs](https://github.com/offfahad/Sketch2Real-FYP/assets/19569802/771895cf-fd73-44ef-8829-6300011d9ec5)
![7500Epochs](https://github.com/offfahad/human-face-sketch-to-real/assets/19569802/60a0f06d-b891-417e-b355-9f1ebb4ddf46)
![10000Epochs](https://github.com/offfahad/human-face-sketch-to-real/assets/19569802/50b7014a-cd50-4e78-9a22-f9ff517c0120)

# Unseen Imgae Result
I try to draw my face sketch and give it to model and results was very accurate and mind blowing! The first one is mine.
![10000Epochs](https://github.com/offfahad/human-face-sketch-to-real/assets/19569802/33549348-c3f3-4767-b5e4-4728f3f7aa3d)
## More Unseen Images Results
![sir-naveed-results](https://github.com/offfahad/human-face-sketch-to-real/assets/19569802/672bd2b0-778c-4706-9dfc-8e1612090385)
![random-girl](https://github.com/offfahad/human-face-sketch-to-real/assets/19569802/5200616a-7d70-469a-81f7-fe3d52126d1f)
![sir-zafar-results](https://github.com/offfahad/human-face-sketch-to-real/assets/19569802/681a68bb-f8c8-4fd6-90e9-1bcb73683315)

## How To Run 
- First run the backend in PyCharm with trained model by getting it from me.
- Then you will get your machine ip address on which your model is currently running. 
- Now add this ip address in to Flutter application so your frontend can talk to backend.

## Credits
- I took the model architecture concept from this paper named as "Image-To-Image Translation With Conditional Generative Adversarial Neural Networks" from https://arxiv.org/abs/1611.07004 because they have provided a commom framework you just have to change the dataset.
-  I trained my model on Google Colab around for 3 months just on training phase due to limited GPU computing units even on the premium subscription.
-  The frontend was also very time taking task due to drawing concepts.
-  If you need the full trained model and dataset which is used in my project you can buy from me for 100$.
-  Gmail: mughalfahad544@gmail.com
