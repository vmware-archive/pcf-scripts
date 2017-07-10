# clear dns cache, only on macs
uname | grep Darwin && sudo killall -HUP mDNSResponder

for i in 1 2 3; do
  sshuttle --verbose --verbose --dns --remote=inner 10/8 \
    --exclude=10.81.0.0/16 --exclude=10.84.0.0/16 --exclude 10.4.0.0/16 \
    --ssh-cmd 'ssh -F config/ssh_config'
done
