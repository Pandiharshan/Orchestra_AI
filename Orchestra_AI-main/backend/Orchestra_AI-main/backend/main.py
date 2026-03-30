from services.orchestration_service import run_orchestration


if __name__ == "__main__":
    goal = input("Enter your goal: ")
    result = run_orchestration(goal)
    print(result["final_result"])
