import re
import subprocess
import sys


def check_signed_off_by(commit_msg_filepath):
    git_username = subprocess.run(["git", "config", "user.name"], stdout=subprocess.PIPE).stdout.strip().decode()
    git_email = subprocess.run(["git", "config", "user.email"], stdout=subprocess.PIPE).stdout.strip().decode()

    my_signoff_regex = r"Signed-off-by:\s"+re.escape(git_username)+"\s<"+re.escape(git_email)+">"
    commit_tailer_regex = r"[A-z-]+-by:\s[A-z-]+\s+[a-zA-Z]+\s<[\w\.-]+@([\w-]+\.)+[\w-]{2,4}>"

    with open(commit_msg_filepath, "r+") as file:
        commit_msg = file.read()
        if not re.search(my_signoff_regex, commit_msg):

            if not re.search(commit_tailer_regex, commit_msg):
                file.write("\n")

                file.write(f"Signed-off-by: {git_username} <{git_email}>\n")

check_signed_off_by(sys.argv[1])
