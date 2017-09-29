FROM alaxalves/api:1.3

MAINTAINER alaxallves@gmail.com

CMD ["sudo", "bundle", "install"]
CMD ["sudo", "rake", "db:create"] 
CMD ["sudo", "rake", "db:migrate"]
CMD ["sudo", "rake","test"]
