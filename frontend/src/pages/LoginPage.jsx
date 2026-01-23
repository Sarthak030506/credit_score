import React, { useState } from 'react'
import { Card } from '../components/common/Card'
import { Input } from '../components/common/Input'
import { Button } from '../components/common/Button'
import { Alert } from '../components/common/Alert'
import { api } from '../services/api'
import { useNavigate } from 'react-router-dom'

export default function LoginPage({ variant = 'citizen', onLogin }) {
    const navigate = useNavigate()
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(null)
    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')

    const titles = {
        citizen: 'Citizen Portal',
        bank: 'Bank Dashboard',
        admin: 'Admin Console'
    }

    const handleLogin = async (e) => {
        e.preventDefault()
        setLoading(true)
        setError(null)

        try {
            const data = await api.login(email, password)

            if (data.user.role !== variant) {
                setError(`This account is not authorized for ${variant} access.`)
                setLoading(false)
                return
            }

            onLogin(data.user, data.token)
            navigate(`/${variant}`)
        } catch (err) {
            console.error(err)
            setError('Invalid email or password')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
            <div className="w-full max-w-md">
                <div className="text-center mb-8">
                    <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-blue-600 to-indigo-600 mx-auto flex items-center justify-center text-white text-2xl font-bold mb-4 shadow-lg">
                        CS
                    </div>
                    <h2 className="text-3xl font-bold text-gray-900">CreditScore AI</h2>
                    <p className="text-gray-500 mt-2">Intelligent Credit Assessment</p>
                </div>

                <Card title={titles[variant]} className="relative overflow-hidden">
                    <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-blue-500 to-indigo-500"></div>

                    <form onSubmit={handleLogin} className="space-y-6">
                        {error && <Alert type="error">{error}</Alert>}

                        <Input
                            label="Email Address"
                            type="email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            placeholder="name@example.com"
                            required
                        />

                        <Input
                            label="Password"
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            placeholder="••••••••"
                            required
                        />

                        <Button
                            type="submit"
                            variant="primary"
                            className="w-full"
                            loading={loading}
                        >
                            Sign In
                        </Button>
                    </form>

                    <div className="mt-6 flex justify-center space-x-4 text-sm text-gray-500">
                        {variant !== 'citizen' && (
                            <a href="/login/citizen" className="hover:text-blue-600 transition-colors">Citizen Login</a>
                        )}
                        {variant !== 'bank' && (
                            <a href="/login/bank" className="hover:text-blue-600 transition-colors">Bank Login</a>
                        )}
                        {variant !== 'admin' && (
                            <a href="/login/admin" className="hover:text-blue-600 transition-colors">Admin Login</a>
                        )}
                    </div>
                </Card>

                <p className="text-center text-sm text-gray-400 mt-8">
                    &copy; 2024 CreditScore AI. Secure System.
                </p>
            </div>
        </div>
    )
}
