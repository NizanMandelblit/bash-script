#!/bin/bash

#Goal:
#The goal of this exercise is to create a shell script that adds users to the same Linux system as the script is executed on.

# Make sure the script is being executed with superuser privileges.
if [ ${UID} == 0 ]; then
  echo "running as root"
else
  echo "need sudo privileges!"
  exit 1
fi

# If the user doesn't supply at least one argument, then give them help.
if [ ${#} -eq 0 ]; then
  echo "correct usage: ${0} USER_NAME [COMMENT]"
fi

# The first parameter is the user name.
USER_NAME=${0}
# The rest of the parameters are for the account comments.
shift
COMMENT=${@}
# Generate a password.
PASSWORD=${date+%s%N | sha256sum | head -c48}

# Create the user with the password.
useradd -c ${COMMENT} -m ${USER_NAME}

# Check to see if the useradd command succeeded.
if [ ${0} == 0 ]; then
  echo "user added"
else
  echo "fail!"
  exit 1
fi

# Set the password.
echo ${PASSWORD} | passwd ${USER_NAME}
# Check to see if the passwd command succeeded.
if [ ${0} != 0 ]; then
  echo "fail creating the password!"
  exit 1
fi
# Force password change on first login.
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo "USER_NAME: ${USER_NAME}"
echo "PASSWORD : ${PASSWORD}"
echo "HOST : ${HOSTNAME}"
