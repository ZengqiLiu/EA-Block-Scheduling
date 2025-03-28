# Sprint 1 MVP Report

### 1. Deployed App
Link: https://ea-block-scheduler-4fecd886e389.herokuapp.com/generate-schedule 


### 2. Sprint Goal
- [x] Create the basic app and deploy it
- [x] Make basic UI for the login page(Button, Header...)

- [x] Schedule generate algorithm
	- When I input mock class data, I should see a list of possible schedules with a simple algorithm, such as separating overlap.
- [x] Build basic UI page like Aggie Schedule Builder
    + It will show the selected classes
    + It has a `Generate` button for generating schedule
    + After generating possible schedules, user can view the schedule through `View` Button

### 3. Sprint Backlog
- [ ] Implement the data structure using sqlite3
- [ ] Admin could upload the spreadsheet
- [ ] The spreadsheet should be stored in database
- [ ] Use 3rd-party authetication.
- [ ] Design the basic user profile page.
- [ ] Spreadsheet can be parsed correctly. After that, data will be stored in database.
- [ ] The schedule chart can show different classes with differen colors.
- [ ] You can check the class detail by moving cursor on the class block.
- [ ] Design a data structure for classes to keep track of my classes and requirements
    + Term
    + Department Code
    + Section Name
    + Bldg, Room
    + Start Time, End Time
    + .....
- [ ] Design a data structure for Student profile data
    + Name
    + UIN
    + email
    + Classes already taken (For prerequisites)
    + .....
- [ ] Show example schedule chart (time, days of week)
- [ ] Set up Code Climate Report

### 4. Use of BDD
All stories have Cucumber feature(s) defined with several scenarios each, all Cucumber scenarios are passing and all steps are defined

### 5. Use of TDD
 All models and controllers have specs with at least one example/expectation, all examples are passing

### 6. Test Coverage
Test coverage generated by SimpleCov is at least 90%.
> Run `bundle exec cucumber` to see the result <br>
> Run `ruby ./test/test_block_generator.rb` to test the block generate algorithm

### 7. Code quality
Code Climate will be set up in the next sprint


### 8. Code Style
All Rubocop cops are enabled and report at most 1 style offense per file.
> Run `rubocop` to see the result <br>

### 9. Use of Project Tracker
**Taiga User Stories:** https://tree.taiga.io/project/aaronjones05-block-scheduler/backlog

## 10. Presentation
See the deployed app.
