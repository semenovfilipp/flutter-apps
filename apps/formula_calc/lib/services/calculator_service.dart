import 'dart:math';

class CalculatorService {
  // New method to solve for any variable
  static String? solveFor(
      String formulaId, String solveFor, Map<String, double> knownValues) {
    try {
      double? result;

      switch (formulaId) {
        // Math formulas
        case 'math_1': // S = πr²
          result = _solveMath1(solveFor, knownValues);
          break;
        case 'math_2': // c² = a² + b²
          result = _solveMath2(solveFor, knownValues);
          break;
        case 'math_3': // V = (4/3)πr³
          result = _solveMath3(solveFor, knownValues);
          break;
        case 'math_4': // D = b² - 4ac
          result = _solveMath4(solveFor, knownValues);
          break;
        case 'math_5': // P = 2(a + b)
          result = _solveMath5(solveFor, knownValues);
          break;
        case 'math_6': // S = ah/2
          result = _solveMath6(solveFor, knownValues);
          break;
        case 'math_7': // C = 2πr
          result = _solveMath7(solveFor, knownValues);
          break;

        // Physics formulas
        case 'physics_1': // F = ma
          result = _solvePhysics1(solveFor, knownValues);
          break;
        case 'physics_2': // E = mv²/2
          result = _solvePhysics2(solveFor, knownValues);
          break;
        case 'physics_3': // I = U/R
          result = _solvePhysics3(solveFor, knownValues);
          break;
        case 'physics_4': // S = v₀t + at²/2
          result = _solvePhysics4(solveFor, knownValues);
          break;
        case 'physics_5': // E = mgh
          result = _solvePhysics5(solveFor, knownValues);
          break;
        case 'physics_6': // P = A/t
          result = _solvePhysics6(solveFor, knownValues);
          break;
        case 'physics_7': // p = F/S
          result = _solvePhysics7(solveFor, knownValues);
          break;
        case 'physics_8': // v = S/t
          result = _solvePhysics8(solveFor, knownValues);
          break;

        // Chemistry formulas
        case 'chemistry_1': // m = nM
          result = _solveChemistry1(solveFor, knownValues);
          break;
        case 'chemistry_2': // c = n/V
          result = _solveChemistry2(solveFor, knownValues);
          break;
        case 'chemistry_3': // ω = (m₁/m) × 100
          result = _solveChemistry3(solveFor, knownValues);
          break;
        case 'chemistry_4': // p = nRT/V
          result = _solveChemistry4(solveFor, knownValues);
          break;
        case 'chemistry_5': // ρ = m/V
          result = _solveChemistry5(solveFor, knownValues);
          break;
        case 'chemistry_6': // pH = -lg[H⁺]
          result = _solveChemistry6(solveFor, knownValues);
          break;
        case 'chemistry_7': // η = (m_практ/m_теор) × 100
          result = _solveChemistry7(solveFor, knownValues);
          break;

        default:
          return 'Ошибка: формула не поддерживается';
      }

      if (result == null || result.isNaN || result.isInfinite) {
        return 'Ошибка: невозможно вычислить';
      }

      return result.toStringAsFixed(4);
    } catch (e) {
      return 'Ошибка вычисления: $e';
    }
  }

  // Math solvers
  static double? _solveMath1(String solveFor, Map<String, double> known) {
    // S = πr²
    if (solveFor == 'S') {
      final r = known['r'];
      if (r == null || r < 0) return null;
      return pi * r * r;
    } else if (solveFor == 'r') {
      final s = known['S'];
      if (s == null || s < 0) return null;
      return sqrt(s / pi);
    }
    return null;
  }

  static double? _solveMath2(String solveFor, Map<String, double> known) {
    // c² = a² + b²
    if (solveFor == 'c') {
      final a = known['a'];
      final b = known['b'];
      if (a == null || b == null || a < 0 || b < 0) return null;
      return sqrt(a * a + b * b);
    } else if (solveFor == 'a') {
      final c = known['c'];
      final b = known['b'];
      if (c == null || b == null || c < 0 || b < 0) return null;
      final result = c * c - b * b;
      if (result < 0) return null;
      return sqrt(result);
    } else if (solveFor == 'b') {
      final c = known['c'];
      final a = known['a'];
      if (c == null || a == null || c < 0 || a < 0) return null;
      final result = c * c - a * a;
      if (result < 0) return null;
      return sqrt(result);
    }
    return null;
  }

  static double? _solveMath3(String solveFor, Map<String, double> known) {
    // V = (4/3)πr³
    if (solveFor == 'V') {
      final r = known['r'];
      if (r == null || r < 0) return null;
      return (4 / 3) * pi * r * r * r;
    } else if (solveFor == 'r') {
      final v = known['V'];
      if (v == null || v < 0) return null;
      return pow(v / ((4 / 3) * pi), 1 / 3).toDouble();
    }
    return null;
  }

  static double? _solveMath4(String solveFor, Map<String, double> known) {
    // D = b² - 4ac
    if (solveFor == 'D') {
      final a = known['a'];
      final b = known['b'];
      final c = known['c'];
      if (a == null || b == null || c == null || a == 0) return null;
      return b * b - 4 * a * c;
    } else if (solveFor == 'a') {
      final d = known['D'];
      final b = known['b'];
      final c = known['c'];
      if (d == null || b == null || c == null || c == 0) return null;
      return (b * b - d) / (4 * c);
    } else if (solveFor == 'b') {
      final d = known['D'];
      final a = known['a'];
      final c = known['c'];
      if (d == null || a == null || c == null) return null;
      final result = d + 4 * a * c;
      if (result < 0) return null;
      return sqrt(result);
    } else if (solveFor == 'c') {
      final d = known['D'];
      final a = known['a'];
      final b = known['b'];
      if (d == null || a == null || b == null || a == 0) return null;
      return (b * b - d) / (4 * a);
    }
    return null;
  }

  static double? _solveMath5(String solveFor, Map<String, double> known) {
    // P = 2(a + b)
    if (solveFor == 'P') {
      final a = known['a'];
      final b = known['b'];
      if (a == null || b == null || a <= 0 || b <= 0) return null;
      return 2 * (a + b);
    } else if (solveFor == 'a') {
      final p = known['P'];
      final b = known['b'];
      if (p == null || b == null || b <= 0) return null;
      return p / 2 - b;
    } else if (solveFor == 'b') {
      final p = known['P'];
      final a = known['a'];
      if (p == null || a == null || a <= 0) return null;
      return p / 2 - a;
    }
    return null;
  }

  static double? _solveMath6(String solveFor, Map<String, double> known) {
    // S = ah/2
    if (solveFor == 'S') {
      final a = known['a'];
      final h = known['h'];
      if (a == null || h == null || a <= 0 || h < 0) return null;
      return 0.5 * a * h;
    } else if (solveFor == 'a') {
      final s = known['S'];
      final h = known['h'];
      if (s == null || h == null || h == 0) return null;
      return 2 * s / h;
    } else if (solveFor == 'h') {
      final s = known['S'];
      final a = known['a'];
      if (s == null || a == null || a == 0) return null;
      return 2 * s / a;
    }
    return null;
  }

  static double? _solveMath7(String solveFor, Map<String, double> known) {
    // C = 2πr
    if (solveFor == 'C') {
      final r = known['r'];
      if (r == null || r < 0) return null;
      return 2 * pi * r;
    } else if (solveFor == 'r') {
      final c = known['C'];
      if (c == null || c < 0) return null;
      return c / (2 * pi);
    }
    return null;
  }

  // Physics solvers
  static double? _solvePhysics1(String solveFor, Map<String, double> known) {
    // F = ma
    if (solveFor == 'F') {
      final m = known['m'];
      final a = known['a'];
      if (m == null || a == null || m < 0) return null;
      return m * a;
    } else if (solveFor == 'm') {
      final f = known['F'];
      final a = known['a'];
      if (f == null || a == null || a == 0) return null;
      return f / a;
    } else if (solveFor == 'a') {
      final f = known['F'];
      final m = known['m'];
      if (f == null || m == null || m == 0) return null;
      return f / m;
    }
    return null;
  }

  static double? _solvePhysics2(String solveFor, Map<String, double> known) {
    // E = mv²/2
    if (solveFor == 'E') {
      final m = known['m'];
      final v = known['v'];
      if (m == null || v == null || m < 0) return null;
      return 0.5 * m * v * v;
    } else if (solveFor == 'm') {
      final e = known['E'];
      final v = known['v'];
      if (e == null || v == null || v == 0) return null;
      return 2 * e / (v * v);
    } else if (solveFor == 'v') {
      final e = known['E'];
      final m = known['m'];
      if (e == null || m == null || m == 0 || e < 0) return null;
      return sqrt(2 * e / m);
    }
    return null;
  }

  static double? _solvePhysics3(String solveFor, Map<String, double> known) {
    // I = U/R
    if (solveFor == 'I') {
      final u = known['U'];
      final r = known['R'];
      if (u == null || r == null || r == 0) return null;
      return u / r;
    } else if (solveFor == 'U') {
      final i = known['I'];
      final r = known['R'];
      if (i == null || r == null) return null;
      return i * r;
    } else if (solveFor == 'R') {
      final u = known['U'];
      final i = known['I'];
      if (u == null || i == null || i == 0) return null;
      return u / i;
    }
    return null;
  }

  static double? _solvePhysics4(String solveFor, Map<String, double> known) {
    // S = v₀t + at²/2
    if (solveFor == 'S') {
      final v0 = known['v₀'];
      final t = known['t'];
      final a = known['a'];
      if (v0 == null || t == null || a == null || t < 0) return null;
      return v0 * t + (a * t * t) / 2;
    } else if (solveFor == 'v₀') {
      final s = known['S'];
      final t = known['t'];
      final a = known['a'];
      if (s == null || t == null || a == null || t == 0) return null;
      return (s - (a * t * t) / 2) / t;
    } else if (solveFor == 't') {
      // This requires solving quadratic equation, which is complex
      // For simplicity, returning null for now
      return null;
    } else if (solveFor == 'a') {
      final s = known['S'];
      final v0 = known['v₀'];
      final t = known['t'];
      if (s == null || v0 == null || t == null || t == 0) return null;
      return 2 * (s - v0 * t) / (t * t);
    }
    return null;
  }

  static double? _solvePhysics5(String solveFor, Map<String, double> known) {
    // E = mgh
    if (solveFor == 'E') {
      final m = known['m'];
      final g = known['g'] ?? 9.8;
      final h = known['h'];
      if (m == null || h == null || m < 0 || h < 0) return null;
      return m * g * h;
    } else if (solveFor == 'm') {
      final e = known['E'];
      final g = known['g'] ?? 9.8;
      final h = known['h'];
      if (e == null || h == null || h == 0 || g == 0) return null;
      return e / (g * h);
    } else if (solveFor == 'g') {
      final e = known['E'];
      final m = known['m'];
      final h = known['h'];
      if (e == null || m == null || h == null || m == 0 || h == 0) return null;
      return e / (m * h);
    } else if (solveFor == 'h') {
      final e = known['E'];
      final m = known['m'];
      final g = known['g'] ?? 9.8;
      if (e == null || m == null || m == 0 || g == 0) return null;
      return e / (m * g);
    }
    return null;
  }

  static double? _solvePhysics6(String solveFor, Map<String, double> known) {
    // P = A/t
    if (solveFor == 'P') {
      final a = known['A'];
      final t = known['t'];
      if (a == null || t == null || t == 0) return null;
      return a / t;
    } else if (solveFor == 'A') {
      final p = known['P'];
      final t = known['t'];
      if (p == null || t == null) return null;
      return p * t;
    } else if (solveFor == 't') {
      final a = known['A'];
      final p = known['P'];
      if (a == null || p == null || p == 0) return null;
      return a / p;
    }
    return null;
  }

  static double? _solvePhysics7(String solveFor, Map<String, double> known) {
    // p = F/S
    if (solveFor == 'p') {
      final f = known['F'];
      final s = known['S'];
      if (f == null || s == null || s == 0) return null;
      return f / s;
    } else if (solveFor == 'F') {
      final p = known['p'];
      final s = known['S'];
      if (p == null || s == null) return null;
      return p * s;
    } else if (solveFor == 'S') {
      final f = known['F'];
      final p = known['p'];
      if (f == null || p == null || p == 0) return null;
      return f / p;
    }
    return null;
  }

  static double? _solvePhysics8(String solveFor, Map<String, double> known) {
    // v = S/t
    if (solveFor == 'v') {
      final s = known['S'];
      final t = known['t'];
      if (s == null || t == null || t == 0) return null;
      return s / t;
    } else if (solveFor == 'S') {
      final v = known['v'];
      final t = known['t'];
      if (v == null || t == null) return null;
      return v * t;
    } else if (solveFor == 't') {
      final s = known['S'];
      final v = known['v'];
      if (s == null || v == null || v == 0) return null;
      return s / v;
    }
    return null;
  }

  // Chemistry solvers
  static double? _solveChemistry1(String solveFor, Map<String, double> known) {
    // m = nM
    if (solveFor == 'm') {
      final n = known['n'];
      final m = known['M'];
      if (n == null || m == null || n < 0) return null;
      return n * m;
    } else if (solveFor == 'n') {
      final m = known['m'];
      final molar = known['M'];
      if (m == null || molar == null || molar == 0) return null;
      return m / molar;
    } else if (solveFor == 'M') {
      final m = known['m'];
      final n = known['n'];
      if (m == null || n == null || n == 0) return null;
      return m / n;
    }
    return null;
  }

  static double? _solveChemistry2(String solveFor, Map<String, double> known) {
    // c = n/V
    if (solveFor == 'c') {
      final n = known['n'];
      final v = known['V'];
      if (n == null || v == null || v == 0) return null;
      return n / v;
    } else if (solveFor == 'n') {
      final c = known['c'];
      final v = known['V'];
      if (c == null || v == null) return null;
      return c * v;
    } else if (solveFor == 'V') {
      final n = known['n'];
      final c = known['c'];
      if (n == null || c == null || c == 0) return null;
      return n / c;
    }
    return null;
  }

  static double? _solveChemistry3(String solveFor, Map<String, double> known) {
    // ω = (m₁/m) × 100
    if (solveFor == 'ω') {
      final m1 = known['m₁'];
      final m = known['m'];
      if (m1 == null || m == null || m == 0) return null;
      return (m1 / m) * 100;
    } else if (solveFor == 'm₁') {
      final omega = known['ω'];
      final m = known['m'];
      if (omega == null || m == null) return null;
      return (omega * m) / 100;
    } else if (solveFor == 'm') {
      final omega = known['ω'];
      final m1 = known['m₁'];
      if (omega == null || m1 == null || omega == 0) return null;
      return (m1 * 100) / omega;
    }
    return null;
  }

  static double? _solveChemistry4(String solveFor, Map<String, double> known) {
    // p = nRT/V
    if (solveFor == 'p') {
      final n = known['n'];
      final r = known['R'] ?? 8.314;
      final t = known['T'];
      final v = known['V'];
      if (n == null || t == null || v == null || v == 0) return null;
      return (n * r * t) / v;
    } else if (solveFor == 'n') {
      final p = known['p'];
      final r = known['R'] ?? 8.314;
      final t = known['T'];
      final v = known['V'];
      if (p == null || t == null || v == null || r == 0 || t == 0) return null;
      return (p * v) / (r * t);
    } else if (solveFor == 'R') {
      final p = known['p'];
      final n = known['n'];
      final t = known['T'];
      final v = known['V'];
      if (p == null || n == null || t == null || v == null || n == 0 || t == 0) {
        return null;
      }
      return (p * v) / (n * t);
    } else if (solveFor == 'T') {
      final p = known['p'];
      final n = known['n'];
      final r = known['R'] ?? 8.314;
      final v = known['V'];
      if (p == null || n == null || v == null || n == 0 || r == 0) return null;
      return (p * v) / (n * r);
    } else if (solveFor == 'V') {
      final p = known['p'];
      final n = known['n'];
      final r = known['R'] ?? 8.314;
      final t = known['T'];
      if (p == null || n == null || t == null || p == 0) return null;
      return (n * r * t) / p;
    }
    return null;
  }

  static double? _solveChemistry5(String solveFor, Map<String, double> known) {
    // ρ = m/V
    if (solveFor == 'ρ') {
      final m = known['m'];
      final v = known['V'];
      if (m == null || v == null || v == 0) return null;
      return m / v;
    } else if (solveFor == 'm') {
      final rho = known['ρ'];
      final v = known['V'];
      if (rho == null || v == null) return null;
      return rho * v;
    } else if (solveFor == 'V') {
      final m = known['m'];
      final rho = known['ρ'];
      if (m == null || rho == null || rho == 0) return null;
      return m / rho;
    }
    return null;
  }

  static double? _solveChemistry6(String solveFor, Map<String, double> known) {
    // pH = -lg[H⁺]
    if (solveFor == 'pH') {
      final h = known['[H⁺]'];
      if (h == null || h <= 0) return null;
      return -log(h) / ln10;
    } else if (solveFor == '[H⁺]') {
      final ph = known['pH'];
      if (ph == null) return null;
      return pow(10, -ph).toDouble();
    }
    return null;
  }

  static double? _solveChemistry7(String solveFor, Map<String, double> known) {
    // η = (m_практ/m_теор) × 100
    if (solveFor == 'η') {
      final mPract = known['m_практ'];
      final mTheor = known['m_теор'];
      if (mPract == null || mTheor == null || mTheor == 0) return null;
      return (mPract / mTheor) * 100;
    } else if (solveFor == 'm_практ') {
      final eta = known['η'];
      final mTheor = known['m_теор'];
      if (eta == null || mTheor == null) return null;
      return (eta * mTheor) / 100;
    } else if (solveFor == 'm_теор') {
      final eta = known['η'];
      final mPract = known['m_практ'];
      if (eta == null || mPract == null || eta == 0) return null;
      return (mPract * 100) / eta;
    }
    return null;
  }

  // Old method - kept for backwards compatibility but not used

  static double? calculateCircleArea(double r) {
    if (r < 0) return null;
    return pi * r * r;
  }

  static double? calculatePythagorean(double a, double b) {
    if (a < 0 || b < 0) return null;
    return sqrt(a * a + b * b);
  }

  static double? calculateSphereVolume(double r) {
    if (r < 0) return null;
    return (4 / 3) * pi * r * r * r;
  }

  static double? calculateDiscriminant(double a, double b, double c) {
    if (a == 0) return null;
    return b * b - 4 * a * c;
  }

  static double? calculateRectanglePerimeter(double a, double b) {
    if (a <= 0 || b <= 0) return null;
    return 2 * (a + b);
  }

  static double? calculateTriangleArea(double a, double h) {
    if (a <= 0 || h < 0) return null;
    return 0.5 * a * h;
  }

  static double? calculateCircleCircumference(double r) {
    if (r < 0) return null;
    return 2 * pi * r;
  }

  static double? calculateNewtonForce(double m, double a) {
    if (m < 0) return null;
    return m * a;
  }

  static double? calculateKineticEnergy(double m, double v) {
    if (m < 0) return null;
    return 0.5 * m * v * v;
  }

  static double? calculateOhmCurrent(double u, double r) {
    if (r == 0) return null;
    return u / r;
  }

  static double? calculateUniformlyAcceleratedMotion(
      double v0, double t, double a) {
    if (t < 0) return null;
    return v0 * t + (a * t * t) / 2;
  }

  static double? calculatePotentialEnergy(double m, double g, double h) {
    if (m < 0 || h < 0) return null;
    return m * g * h;
  }

  static double? calculatePower(double a, double t) {
    if (t == 0) return null;
    return a / t;
  }

  static double? calculatePressure(double f, double s) {
    if (s == 0) return null;
    return f / s;
  }

  static double? calculateSpeed(double s, double t) {
    if (t == 0) return null;
    return s / t;
  }

  static double? calculateMolarMass(double n, double m) {
    if (n < 0) return null;
    return n * m;
  }

  static double? calculateConcentration(double n, double v) {
    if (v == 0) return null;
    return n / v;
  }

  static double? calculateMassFraction(double m1, double m) {
    if (m == 0) return null;
    return (m1 / m) * 100;
  }

  static double? calculateIdealGasPressure(
      double n, double r, double t, double v) {
    if (v == 0) return null;
    return (n * r * t) / v;
  }

  static double? calculateDensity(double m, double v) {
    if (v == 0) return null;
    return m / v;
  }

  static double? calculatePH(double h) {
    if (h <= 0) return null;
    return -log(h) / ln10;
  }

  static double? calculateYield(double mPract, double mTheor) {
    if (mTheor == 0) return null;
    return (mPract / mTheor) * 100;
  }

  static String? calculate(String formulaId, Map<String, double> values) {
    try {
      double? result;

      switch (formulaId) {
        case 'math_1': // Circle area
          result = calculateCircleArea(values['r'] ?? 0);
          break;
        case 'math_2': // Pythagorean
          result = calculatePythagorean(values['a'] ?? 0, values['b'] ?? 0);
          break;
        case 'math_3': // Sphere volume
          result = calculateSphereVolume(values['r'] ?? 0);
          break;
        case 'math_4': // Discriminant
          result = calculateDiscriminant(
              values['a'] ?? 0, values['b'] ?? 0, values['c'] ?? 0);
          break;
        case 'math_5': // Rectangle perimeter
          result =
              calculateRectanglePerimeter(values['a'] ?? 0, values['b'] ?? 0);
          break;
        case 'math_6': // Triangle area
          result = calculateTriangleArea(values['a'] ?? 0, values['h'] ?? 0);
          break;
        case 'math_7': // Circle circumference
          result = calculateCircleCircumference(values['r'] ?? 0);
          break;
        case 'physics_1': // Newton's force
          result = calculateNewtonForce(values['m'] ?? 0, values['a'] ?? 0);
          break;
        case 'physics_2': // Kinetic energy
          result = calculateKineticEnergy(values['m'] ?? 0, values['v'] ?? 0);
          break;
        case 'physics_3': // Ohm's law
          result = calculateOhmCurrent(values['U'] ?? 0, values['R'] ?? 0);
          break;
        case 'physics_4': // Uniformly accelerated motion
          result = calculateUniformlyAcceleratedMotion(
              values['v₀'] ?? 0, values['t'] ?? 0, values['a'] ?? 0);
          break;
        case 'physics_5': // Potential energy
          result = calculatePotentialEnergy(
              values['m'] ?? 0, values['g'] ?? 9.8, values['h'] ?? 0);
          break;
        case 'physics_6': // Power
          result = calculatePower(values['A'] ?? 0, values['t'] ?? 0);
          break;
        case 'physics_7': // Pressure
          result = calculatePressure(values['F'] ?? 0, values['S'] ?? 0);
          break;
        case 'physics_8': // Speed
          result = calculateSpeed(values['S'] ?? 0, values['t'] ?? 0);
          break;
        case 'chemistry_1': // Molar mass
          result = calculateMolarMass(values['n'] ?? 0, values['M'] ?? 0);
          break;
        case 'chemistry_2': // Concentration
          result = calculateConcentration(values['n'] ?? 0, values['V'] ?? 0);
          break;
        case 'chemistry_3': // Mass fraction
          result = calculateMassFraction(values['m₁'] ?? 0, values['m'] ?? 0);
          break;
        case 'chemistry_4': // Ideal gas law
          result = calculateIdealGasPressure(values['n'] ?? 0,
              values['R'] ?? 8.314, values['T'] ?? 0, values['V'] ?? 0);
          break;
        case 'chemistry_5': // Density
          result = calculateDensity(values['m'] ?? 0, values['V'] ?? 0);
          break;
        case 'chemistry_6': // pH
          result = calculatePH(values['[H⁺]'] ?? 0);
          break;
        case 'chemistry_7': // Yield
          result = calculateYield(
              values['m_практ'] ?? 0, values['m_теор'] ?? 0);
          break;
        default:
          return 'Формула не поддерживается';
      }

      if (result == null) {
        return 'Ошибка: некорректные значения';
      }

      // Round to 4 decimal places
      return result.toStringAsFixed(4);
    } catch (e) {
      return 'Ошибка вычисления: $e';
    }
  }
}
