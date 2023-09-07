MAIN = ./main.rb
SRC = matrix.rb joy_stick.rb target.rb task.rb scheduler.rb game.rb

$(MAIN) : $(SRC)
	@echo "" > $(MAIN)
	@for file in $(SRC); do \
		cat $$file >> $(MAIN); \
	done
	@mrbc $(MAIN)

.PHONY: clean
clean:
	@rm $(MAIN)
