# Sync All repo at once :
for i in $(hammer --csv repository list --organization $SET_ORG | grep -vi '^ID' | awk -F, {'print $1'})
do
  hammer repository synchronize --id ${i} --organization $SET_ORG --async
done
