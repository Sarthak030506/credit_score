"""
Generate comprehensive sample transaction data for the Credit Score app.
"""
import json
import random
from datetime import datetime, timedelta

def generate_transactions(profile: str, months: int = 12) -> list:
    """Generate realistic transaction data based on credit profile."""

    transactions = []
    start_date = datetime(2023, 1, 1)

    # Profile configurations
    profiles = {
        'excellent': {
            'salary': (8000, 15000),
            'salary_variation': 0.05,
            'expense_ratio': (0.4, 0.6),
            'savings_rate': 0.2,
            'overdraft_chance': 0,
            'late_payment_chance': 0,
            'categories': {
                'Rent': (0.2, 0.25),
                'Utilities': (0.03, 0.05),
                'Groceries': (0.08, 0.12),
                'Transport': (0.03, 0.05),
                'Entertainment': (0.02, 0.04),
                'Healthcare': (0.01, 0.02),
                'Investments': (0.15, 0.25),
                'Shopping': (0.03, 0.06),
            }
        },
        'very_good': {
            'salary': (6000, 10000),
            'salary_variation': 0.08,
            'expense_ratio': (0.5, 0.7),
            'savings_rate': 0.15,
            'overdraft_chance': 0.02,
            'late_payment_chance': 0.05,
            'categories': {
                'Rent': (0.22, 0.28),
                'Utilities': (0.04, 0.06),
                'Groceries': (0.10, 0.14),
                'Transport': (0.04, 0.06),
                'Entertainment': (0.03, 0.05),
                'Healthcare': (0.01, 0.03),
                'Investments': (0.08, 0.15),
                'Shopping': (0.05, 0.08),
            }
        },
        'good': {
            'salary': (4000, 7000),
            'salary_variation': 0.12,
            'expense_ratio': (0.65, 0.8),
            'savings_rate': 0.08,
            'overdraft_chance': 0.05,
            'late_payment_chance': 0.1,
            'categories': {
                'Rent': (0.25, 0.32),
                'Utilities': (0.05, 0.07),
                'Groceries': (0.12, 0.16),
                'Transport': (0.05, 0.08),
                'Entertainment': (0.04, 0.06),
                'Healthcare': (0.02, 0.04),
                'Investments': (0.02, 0.06),
                'Shopping': (0.06, 0.10),
            }
        },
        'fair': {
            'salary': (3000, 5000),
            'salary_variation': 0.2,
            'expense_ratio': (0.8, 0.95),
            'savings_rate': 0.02,
            'overdraft_chance': 0.15,
            'late_payment_chance': 0.2,
            'categories': {
                'Rent': (0.30, 0.38),
                'Utilities': (0.06, 0.09),
                'Groceries': (0.14, 0.18),
                'Transport': (0.06, 0.10),
                'Entertainment': (0.05, 0.08),
                'Healthcare': (0.02, 0.04),
                'CreditCardBill': (0.05, 0.12),
                'Shopping': (0.08, 0.14),
            }
        },
        'poor': {
            'salary': (2000, 3500),
            'salary_variation': 0.35,
            'expense_ratio': (0.95, 1.1),
            'savings_rate': 0,
            'overdraft_chance': 0.3,
            'late_payment_chance': 0.4,
            'categories': {
                'Rent': (0.35, 0.45),
                'Utilities': (0.08, 0.12),
                'Groceries': (0.15, 0.22),
                'Transport': (0.08, 0.12),
                'Entertainment': (0.06, 0.10),
                'CreditCardBill': (0.10, 0.20),
                'Shopping': (0.10, 0.18),
            }
        }
    }

    config = profiles[profile]
    base_salary = random.uniform(*config['salary'])
    balance = base_salary * random.uniform(1.5, 3)  # Starting balance

    for month in range(months):
        month_start = start_date + timedelta(days=month * 30)

        # Salary (with occasional variation or missed payments for poor profiles)
        if random.random() > config['late_payment_chance']:
            salary_day = random.randint(1, 5)
            salary = base_salary * (1 + random.uniform(-config['salary_variation'], config['salary_variation']))

            # Sometimes add bonus for excellent profiles
            if profile == 'excellent' and month % 3 == 0:
                salary *= random.uniform(1.1, 1.3)

            balance += salary
            transactions.append({
                'date': (month_start + timedelta(days=salary_day)).strftime('%Y-%m-%d'),
                'amount': round(salary, 2),
                'category': 'Salary',
                'type': 'credit',
                'balance': round(balance, 2)
            })

            # Occasional freelance income for some profiles
            if profile in ['excellent', 'very_good'] and random.random() < 0.3:
                freelance = random.uniform(500, 2000)
                balance += freelance
                transactions.append({
                    'date': (month_start + timedelta(days=random.randint(10, 25))).strftime('%Y-%m-%d'),
                    'amount': round(freelance, 2),
                    'category': 'Freelance',
                    'type': 'credit',
                    'balance': round(balance, 2)
                })

        # Monthly expenses
        monthly_income = base_salary
        expense_ratio = random.uniform(*config['expense_ratio'])
        total_expense_budget = monthly_income * expense_ratio

        for category, (min_pct, max_pct) in config['categories'].items():
            expense_pct = random.uniform(min_pct, max_pct)
            expense_amount = total_expense_budget * expense_pct

            # Split some categories into multiple transactions
            if category in ['Groceries', 'Transport', 'Entertainment', 'Shopping']:
                num_transactions = random.randint(2, 6)
                for i in range(num_transactions):
                    tx_amount = expense_amount / num_transactions * random.uniform(0.7, 1.3)
                    tx_day = random.randint(1, 28)
                    balance -= tx_amount

                    # Check for overdraft
                    if balance < 0 and random.random() > config['overdraft_chance']:
                        balance = random.uniform(50, 500)  # Avoid overdraft

                    transactions.append({
                        'date': (month_start + timedelta(days=tx_day)).strftime('%Y-%m-%d'),
                        'amount': round(tx_amount, 2),
                        'category': category,
                        'type': 'debit',
                        'balance': round(balance, 2)
                    })
            else:
                # Single monthly payment (rent, utilities, etc.)
                tx_day = random.randint(1, 10) if category == 'Rent' else random.randint(5, 20)
                balance -= expense_amount

                if balance < 0 and random.random() > config['overdraft_chance']:
                    balance = random.uniform(50, 500)

                transactions.append({
                    'date': (month_start + timedelta(days=tx_day)).strftime('%Y-%m-%d'),
                    'amount': round(expense_amount, 2),
                    'category': category,
                    'type': 'debit',
                    'balance': round(balance, 2)
                })

        # Savings/Investments for good profiles
        if config['savings_rate'] > 0 and random.random() < 0.8:
            savings = monthly_income * config['savings_rate'] * random.uniform(0.8, 1.2)
            balance -= savings
            transactions.append({
                'date': (month_start + timedelta(days=random.randint(5, 15))).strftime('%Y-%m-%d'),
                'amount': round(savings, 2),
                'category': 'Savings',
                'type': 'debit',
                'balance': round(balance, 2)
            })

    # Sort by date
    transactions.sort(key=lambda x: x['date'])

    return transactions

def main():
    """Generate and save sample data."""
    print("Generating comprehensive sample data...")

    samples = {
        'excellent': generate_transactions('excellent', months=12),
        'very_good': generate_transactions('very_good', months=12),
        'good': generate_transactions('good', months=12),
        'fair': generate_transactions('fair', months=12),
        'poor': generate_transactions('poor', months=12),
    }

    # Save to assets
    output_path = 'assets/ml/sample_data.json'
    with open(output_path, 'w') as f:
        json.dump(samples, f, indent=2)

    print(f"\nGenerated sample data:")
    for profile, transactions in samples.items():
        income = sum(t['amount'] for t in transactions if t['type'] == 'credit')
        expenses = sum(t['amount'] for t in transactions if t['type'] == 'debit')
        print(f"  {profile}: {len(transactions)} transactions, Income: ${income:,.0f}, Expenses: ${expenses:,.0f}")

    print(f"\nSaved to: {output_path}")

if __name__ == '__main__':
    main()
