.PHONY: all daemon restore clean

all: malicious_dir

malicious_dir:
	mkdir -p malicious_dir

daemon: malicious_dir
	chmod +x antivirusd.sh
	./antivirusd.sh monitored/ malicious_dir 5

restore:
	chmod +x restore.sh
	./restore.sh monitored/ malicious_dir

clean:
	rm -f directory-info.last directory-info.new
