Feature: Prophecy
  In order to utilize Prophecy in my test cases
  As a Psalm user
  I need Psalm to typecheck my prophecies

  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm totallyTyped="true" %s>
        <projectFiles>
          <directory name="."/>
          <ignoreFiles> <directory name="../../vendor"/> </ignoreFiles>
        </projectFiles>
        <plugins>
          <pluginClass class="Psalm\PhpUnitPlugin\Plugin"/>
        </plugins>
      </psalm>
      """
    And I have the following code preamble
      """
      <?php
      namespace NS;
      use PHPUnit\Framework\TestCase;
      use Prophecy\Argument;

      """

  Scenario: Argument::that() accepts callable with no parameters
    Given I have the following code
      """
      class MyTestCase extends TestCase
      {
        /** @return void */
        public function testSomething() {
          $argument = Argument::that(function () {
            return true;
          });
        }
      }
      """
    When I run Psalm
    Then I see no errors

  Scenario: Argument::that() accepts callable with one parameter
    Given I have the following code
      """
      class MyTestCase extends TestCase
      {
        /** @return void */
        public function testSomething() {
          $argument = Argument::that(function (int $i) {
            return $i > 0;
          });
        }
      }
      """
    When I run Psalm
    Then I see no errors

  Scenario: Argument::that() accepts callable with multiple parameters
    Given I have the following code
      """
      class MyTestCase extends TestCase
      {
        /** @return void */
        public function testSomething() {
          $argument = Argument::that(function (int $i, int $j, int $k) {
            return ($i + $j + $k) > 0;
          });
        }
      }
      """
    When I run Psalm
    Then I see no errors

  Scenario: Argument::that() only accepts callable with boolean return type
    Given I have the following code
      """
      class MyTestCase extends TestCase
      {
        /** @return void */
        public function testSomething() {
          $argument = Argument::that(function (): string {
            return 'hello';
          });
        }
      }
      """
    When I run Psalm
    Then I see these errors
      | InvalidScalarArgument | Argument 1 of Prophecy\Argument::that expects callable(mixed...):bool, Closure():string(hello) provided |
