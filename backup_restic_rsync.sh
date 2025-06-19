


restic -r /media/nas-storage/restic-backup init

sudo mount 192.168.10.7:/volume1/bkp_rsync /media/nas-storage  

restic -r /media/nas-storage/restic-backup backup backup
restic -r /media/nas-storage/restic-backup backup bin
restic -r /media/nas-storage/restic-backup backup .config
restic -r /media/nas-storage/restic-backup backup developer
restic -r /media/nas-storage/restic-backup backup .wine

rsync -avzAX --delete-excluded /home/acoliveira/backup /media/acoliveira/mint-backup/backup
rsync -avzAX --delete-excluded /home/acoliveira/bin /media/acoliveira/mint-backup/bin
rsync -avzAX --delete-excluded /home/acoliveira/.config /media/acoliveira/mint-backup/config
rsync -avzAX --delete-excluded /home/acoliveira/developer /media/acoliveira/mint-backup/developer
rsync -avzAX --delete-excluded /home/acoliveira/.wine /media/acoliveira/mint-backup/wine
