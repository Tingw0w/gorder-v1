#make gen
.PHONY: gen
gen: genproto genopenapi



.PHONY: genproto
genproto:
	#@. -> 当前目录
	@./scripts/genproto.sh

.PHONY: genopenapi
genopenapi:
	@./scripts/genopenapi.sh
