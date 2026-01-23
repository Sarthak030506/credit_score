import React, { useRef, useState } from 'react'
import { Card } from '../common/Card'
import { Button } from '../common/Button'
import { Alert } from '../common/Alert'
import { api } from '../../services/api'

export default function TransactionUpload({ onScoreUpdate }) {
    const fileInputRef = useRef(null)
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(null)

    const handleFileUpload = async (event) => {
        const file = event.target.files[0]
        if (!file) return

        setLoading(true)
        setError(null)

        const reader = new FileReader()
        reader.onload = async (e) => {
            try {
                const text = e.target.result
                const data = await api.citizenScoreFromCSV(text)
                onScoreUpdate(data)
            } catch (err) {
                console.error(err)
                setError('Failed to analyze transactions. Please check the CSV format.')
            } finally {
                setLoading(false)
                // Reset file input
                if (fileInputRef.current) fileInputRef.current.value = ''
            }
        }
        reader.readAsText(file)
    }

    return (
        <Card title="Upload Transactions" subtitle="Upload your CSV bank statement to get your credit score">
            <div className="space-y-4">
                {error && <Alert type="error">{error}</Alert>}

                <div className="border-2 border-dashed border-gray-300 rounded-xl p-8 text-center hover:border-blue-400 transition-colors bg-gray-50/50">
                    <svg className="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
                        <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                    </svg>
                    <p className="mt-2 text-sm text-gray-600">
                        Drag and drop your CSV file here, or click to browse
                    </p>
                    <input
                        type="file"
                        ref={fileInputRef}
                        className="hidden"
                        accept=".csv"
                        onChange={handleFileUpload}
                    />
                    <div className="mt-4">
                        <Button
                            onClick={() => fileInputRef.current?.click()}
                            loading={loading}
                        >
                            Select CSV File
                        </Button>
                    </div>
                    <p className="mt-2 text-xs text-gray-400">
                        Supported keys: Date, Description, Amount, Category
                    </p>
                </div>
            </div>
        </Card>
    )
}
