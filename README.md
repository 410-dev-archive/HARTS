# HARTS Lockdown Browser

### Home Anticheat Remote Testing System

A secure lockdown browser for students to safely take test under COVID-19 pandemic



#### Precompiled Application Launch Requirements

1. macOS 10.14+ Non VM
2. 100MB or more in disk space



#### Development Requirements

- For Frontend
  - macOS 10.14+ Non VM
  - Xcode 11+
    - Xcode includes Python 3
  - Python 3.7.x
- For Backend (Cheat Detection / Authentication Server)
  - Python 3.7.x
- For Backend (OrtaOS / Security)
  - gcc
  - shc
  - bash



#### How to run

1. Download latest complete build (HARTS.Launcher.zip) from [releases](https://github.com/410-dev/HARTS/releases)

2. Get Python 3.7 ready

3. Open 3 terminal windows

4. Type the following command to each windows

      ```
      curl -Ls "https://raw.githubusercontent.com/410-dev/HARTS/master/HARTS%20SERVER/EchoServer/Student-SessionMGR/Server.py?token=AN4ZYCW3IYX4PY62CE4DLKK7C6EIS" -o ./Server.py
      python3 ./Server.py
      ```

      ```
      curl -Ls "https://raw.githubusercontent.com/410-dev/HARTS/master/HARTS%20SERVER/EchoServer/Student-TeacherSession/Teacher.py?token=AN4ZYCTYMEMVP3JQXXOUP7K7C6D6S" -o ./Teacher.py
      python3 ./Teacher.py
      ```

      ```
      mkdir -p /tmp/HARTS; echo "NO_SIGNING NO_VM_DETECTION" > /tmp/HARTS/bootargs
      ~/Downloads/HARTS\ Launcher.app/Contents/MacOS/HARTS\ Launcher debug
      ```

5. Session ID: 

   ```
   gt5c5i
   ```

   Possible Usernames:

   ```
   Benjamin Franklin
   Ivan Ko
   Sherlock Holmes
   ```

   Session password:

   ```
   ng6a9h
   ```
