from app import create_app

app = create_app()

if __name__ == '__main__':
    print("\n" + "="*50)
    print("  FunFinder is running!")
    print("  Open in browser: http://localhost:5000")
    print("="*50 + "\n")
    app.run(debug=False, host='0.0.0.0', port=5000)
