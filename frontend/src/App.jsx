import React, { useState, useEffect } from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'

import LoginPage from './pages/LoginPage'
import CitizenDashboard from './pages/CitizenDashboard'
import BankDashboard from './pages/BankDashboard'
import AdminPanel from './pages/AdminPanel'

function ProtectedRoute({ user, allowedRole, children }) {
  if (!user) {
    return <Navigate to="/login" replace />
  }

  if (allowedRole && user.role !== allowedRole) {
    // If logged in but wrong role, redirect to their actual dashboard
    return <Navigate to={`/${user.role}`} replace />
  }

  return children
}

function App() {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Check for existing session
    const token = localStorage.getItem('token')
    const storedUser = localStorage.getItem('user')

    if (token && storedUser) {
      try {
        const parsed = JSON.parse(storedUser)
        if (parsed && parsed.role) {
          setUser(parsed)
        }
      } catch (e) {
        localStorage.removeItem('token')
        localStorage.removeItem('user')
      }
    }
    setLoading(false)
  }, [])

  const handleLogin = (userData, token) => {
    localStorage.setItem('token', token)
    localStorage.setItem('user', JSON.stringify(userData))
    setUser(userData)
  }

  const handleLogout = () => {
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    setUser(null)
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-100">
        <div className="spinner"></div>
      </div>
    )
  }

  return (
    <Routes>
      <Route
        path="/login"
        element={<Navigate to="/login/citizen" replace />}
      />

      <Route
        path="/login/citizen"
        element={
          user ? <Navigate to={`/${user.role}`} replace /> : <LoginPage variant="citizen" onLogin={handleLogin} />
        }
      />

      <Route
        path="/login/bank"
        element={
          user ? <Navigate to={`/${user.role}`} replace /> : <LoginPage variant="bank" onLogin={handleLogin} />
        }
      />

      <Route
        path="/login/admin"
        element={
          user ? <Navigate to={`/${user.role}`} replace /> : <LoginPage variant="admin" onLogin={handleLogin} />
        }
      />

      <Route
        path="/citizen"
        element={
          <ProtectedRoute user={user} allowedRole="citizen">
            <CitizenDashboard user={user} onLogout={handleLogout} />
          </ProtectedRoute>
        }
      />

      <Route
        path="/bank"
        element={
          <ProtectedRoute user={user} allowedRole="bank">
            <BankDashboard user={user} onLogout={handleLogout} />
          </ProtectedRoute>
        }
      />

      <Route
        path="/admin"
        element={
          <ProtectedRoute user={user} allowedRole="admin">
            <AdminPanel user={user} onLogout={handleLogout} />
          </ProtectedRoute>
        }
      />

      {/* Default redirect */}
      <Route
        path="*"
        element={
          user ? <Navigate to={`/${user.role}`} replace /> : <Navigate to="/login" replace />
        }
      />
    </Routes>
  )
}

export default App
