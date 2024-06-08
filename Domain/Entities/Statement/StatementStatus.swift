public enum StatementStatus {
  case completed

  public static func from(string: String) -> StatementStatus? {
    switch string {
    case "COMPLETED": return .completed
    default: return nil
    }
  }
}
