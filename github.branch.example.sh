##How to branch with your ssh keys.
git clone https://github.com/whereiskurt/kvmlab
git branch v1.0

git remote remove origin 
git remote add origin https://github.com/whereiskurt/kvmlab.git

##Test your keys...
ssh -T git@github.com

## Make changes...
git push --set-upstream origin v1.0

git commit -m "-Changes, yadda yadda..."

##Netx push doesn't need v1.0...
git push