import React from 'react'
import { Header } from './Header'

export function Layout({ children, user, onLogout, fullWidth = false }) {
    return (
        <div className="min-h-screen bg-gray-50">
            <Header user={user} onLogout={onLogout} />
            <main className={`py-8 ${!fullWidth ? 'max-w-7xl mx-auto px-4 sm:px-6 lg:px-8' : ''}`}>
                <div className="animate-enter">
                    {children}
                </div>
            </main>
        </div>
    )
}
