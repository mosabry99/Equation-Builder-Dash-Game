import 'dart:math';

class EquationManager {
  int level;
  late int target;
  List<String> currentEquation = [];
  final Random _random = Random();

  EquationManager({required this.level}) {
    _generateTarget();
  }

  void _generateTarget() {
    // Generate target based on level
    switch (level) {
      case 1:
        target = _random.nextInt(15) + 5; // 5-19
        break;
      case 2:
        target = _random.nextInt(20) + 5; // 5-24
        break;
      case 3:
        target = _random.nextInt(30) + 10; // 10-39
        break;
      default:
        target = _random.nextInt(50) + 10; // 10-59
    }
  }

  List<String> getAvailableValues() {
    List<String> values = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    
    // Increase operator frequency by adding them multiple times
    switch (level) {
      case 1:
        // Add '+' operator 3 times for higher spawn rate
        values.addAll(['+', '+', '+']);
        break;
      case 2:
        // Add operators 3 times each
        values.addAll(['+', '+', '+', '-', '-', '-']);
        break;
      case 3:
      default:
        // Add all operators 3 times each for frequent spawning
        values.addAll([
          '+', '+', '+',
          '-', '-', '-',
          '×', '×', '×',
          '÷', '÷', '÷',
        ]);
    }
    
    return values;
  }

  void addToEquation(String value) {
    // Prevent adding operators at the start or consecutively
    if (_isOperator(value)) {
      if (currentEquation.isEmpty) return;
      if (currentEquation.isNotEmpty && _isOperator(currentEquation.last)) {
        return;
      }
    }
    
    currentEquation.add(value);
  }

  void removeLastFromEquation() {
    if (currentEquation.isNotEmpty) {
      currentEquation.removeLast();
    }
  }

  bool _isOperator(String value) {
    return value == '+' || value == '-' || value == '×' || value == '÷';
  }

  bool validateEquation() {
    if (currentEquation.isEmpty) return false;
    if (_isOperator(currentEquation.last)) return false;
    
    try {
      final result = _evaluateEquation();
      return result == target;
    } catch (e) {
      return false;
    }
  }

  double _evaluateEquation() {
    if (currentEquation.isEmpty) return 0;
    
    // Build a list of numbers and operators
    List<dynamic> tokens = [];
    String currentNumber = '';
    
    for (String char in currentEquation) {
      if (_isOperator(char)) {
        if (currentNumber.isNotEmpty) {
          tokens.add(double.parse(currentNumber));
          currentNumber = '';
        }
        tokens.add(char);
      } else {
        currentNumber += char;
      }
    }
    
    if (currentNumber.isNotEmpty) {
      tokens.add(double.parse(currentNumber));
    }
    
    // Handle multiplication and division first
    for (int i = 1; i < tokens.length; i += 2) {
      if (tokens[i] == '×' || tokens[i] == '÷') {
        double left = tokens[i - 1] as double;
        double right = tokens[i + 1] as double;
        double result;
        
        if (tokens[i] == '×') {
          result = left * right;
        } else {
          if (right == 0) throw Exception('Division by zero');
          result = left / right;
        }
        
        tokens[i - 1] = result;
        tokens.removeRange(i, i + 2);
        i -= 2;
      }
    }
    
    // Handle addition and subtraction
    double result = tokens[0] as double;
    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i] as String;
      double operand = tokens[i + 1] as double;
      
      if (operator == '+') {
        result += operand;
      } else if (operator == '-') {
        result -= operand;
      }
    }
    
    return result;
  }

  String getEquationString() {
    return currentEquation.join(' ');
  }

  void reset() {
    currentEquation.clear();
  }

  void levelUp(int newLevel) {
    level = newLevel;
    currentEquation.clear();
    _generateTarget();
  }

  int getLevel() => level;
  int getTarget() => target;
  
  // Get current equation result (if valid)
  int? getCurrentResult() {
    if (currentEquation.isEmpty) return null;
    if (_isOperator(currentEquation.last)) return null;
    
    try {
      final result = _evaluateEquation();
      return result.round();
    } catch (e) {
      return null;
    }
  }
  
  // Check if current equation equals target
  bool equalsTarget() {
    final result = getCurrentResult();
    return result != null && result == target;
  }
  
  // Check if it's still possible to reach target
  bool canStillReachTarget() {
    if (currentEquation.isEmpty) return true;
    
    try {
      final currentResult = getCurrentResult();
      if (currentResult == null) return true; // Still building equation
      
      // If we've already exceeded target significantly with multiplication/division available
      if (level >= 3) {
        // With multiply/divide, we can still reach many values
        return true;
      }
      
      // For addition/subtraction only (levels 1-2)
      // If current result is much higher than target, it may be impossible
      if (currentResult > target + 50) return false;
      
      // Still possible to reach
      return true;
    } catch (e) {
      return true; // If we can't evaluate, assume it's still possible
    }
  }
  
  // Check if equation is impossible to reach target
  bool isImpossibleToReachTarget() {
    if (currentEquation.isEmpty) return false;
    
    try {
      final currentResult = getCurrentResult();
      if (currentResult == null) return false;
      
      // Check if we've collected enough numbers that make it impossible
      // For level 1 (only addition), if we're way over, it's impossible
      if (level == 1 && currentResult > target + 20) {
        return true;
      }
      
      // For level 2 (addition and subtraction), we have more flexibility
      if (level == 2 && currentResult > target + 50) {
        // Even with subtraction, it might be hard
        return true;
      }
      
      // For levels with multiply/divide, almost always possible
      return false;
    } catch (e) {
      return false;
    }
  }
}
