import React from 'react'
import { Link, useNavigate } from 'react-router-dom'

export function Header({ user, onLogout }) {
    const navigate = useNavigate()

    return (
        <header className="sticky top-0 z-50 w-full bg-white/80 backdrop-blur-md border-b border-gray-100">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="flex justify-between items-center h-16">
                    <div className="flex items-center cursor-pointer" onClick={() => navigate('/')}>
                        <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-blue-600 to-indigo-600 flex items-center justify-center text-white font-bold mr-3">
                            CS
                        </div>
                        <span className="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">
                            CreditScore AI
                        </span>
                    </div>

                    <div className="flex items-center space-x-4">
                        {user && (
                            <>
                                <div className="text-sm text-right hidden sm:block">
                                    <p className="font-medium text-gray-900">{user.name || user.email}</p>
                                    <p className="text-xs text-gray-500 capitalize">{user.role}</p>
                                </div>
                                <div className="h-8 w-px bg-gray-200 hidden sm:block"></div>
                                <button
                                    onClick={onLogout}
                                    className="text-sm text-gray-600 hover:text-red-600 font-medium transition-colors"
                                >
                                    Sign Out
                                </button>
                            </>
                        )}
                        {!user && (
                            <Link to="/login" className="text-sm font-medium text-blue-600 hover:text-blue-700">
                                Sign In
                            </Link>
                        )}
                    </div>
                </div>
            </div>
        </header>
    )
}
