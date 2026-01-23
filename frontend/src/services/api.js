import axios from 'axios'

const API_BASE_URL = '/api'

// Create axios instance
const axiosInstance = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
})

// Add auth token to requests
axiosInstance.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Handle auth errors
axiosInstance.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export const api = {
  // Auth
  login: async (email, password) => {
    const response = await axiosInstance.post('/auth/login', { email, password })
    return response.data
  },

  verify: async () => {
    const response = await axiosInstance.get('/auth/verify')
    return response.data
  },

  // Citizen endpoints
  citizenScore: async (transactions) => {
    const response = await axiosInstance.post('/citizen/score', { transactions })
    return response.data
  },

  citizenScoreFromCSV: async (csvContent) => {
    const response = await axiosInstance.post('/citizen/score', { csv_content: csvContent })
    return response.data
  },

  citizenSampleAnalysis: async () => {
    const response = await axiosInstance.get('/citizen/sample-analysis')
    return response.data
  },

  // Bank endpoints
  bankScore: async (applicantId, transactions) => {
    const response = await axiosInstance.post('/bank/score', {
      applicant_id: applicantId,
      transactions
    })
    return response.data
  },

  bankScoreFromCSV: async (applicantId, csvContent) => {
    const response = await axiosInstance.post('/bank/score', {
      applicant_id: applicantId,
      csv_content: csvContent
    })
    return response.data
  },

  bankBatch: async (applicants) => {
    const response = await axiosInstance.post('/bank/batch', { applicants })
    return response.data
  },

  bankThresholds: async () => {
    const response = await axiosInstance.get('/bank/thresholds')
    return response.data
  },

  // Admin endpoints
  getAuditLogs: async (params = {}) => {
    const response = await axiosInstance.get('/admin/audit', { params })
    return response.data
  },

  getStats: async () => {
    const response = await axiosInstance.get('/admin/stats')
    return response.data
  },

  getUsers: async () => {
    const response = await axiosInstance.get('/admin/users')
    return response.data
  },

  systemHealth: async () => {
    const response = await axiosInstance.get('/admin/health')
    return response.data
  }
}

export default api
