import React, { useState } from 'react'
import { Layout } from '../components/common/Layout'
import { Card } from '../components/common/Card'
import { Button } from '../components/common/Button'
import ApplicantList from '../components/bank/ApplicantList'
import BatchUpload from '../components/bank/BatchUpload'

export default function BankDashboard({ user, onLogout }) {
    // Mock data for initial display
    const [applicants, setApplicants] = useState([
        { id: 1, applicant_id: 'APP-001', created_at: '2024-01-20', score: 785, status: 'Approved' },
        { id: 2, applicant_id: 'APP-002', created_at: '2024-01-21', score: 620, status: 'Review' },
        { id: 3, applicant_id: 'APP-003', created_at: '2024-01-22', score: 450, status: 'Rejected' },
    ])

    const handleRefresh = () => {
        console.log('Refreshing data...')
        // Fetch from API
    }

    const handleViewApplicant = (app) => {
        console.log('View', app)
    }

    return (
        <Layout user={user} onLogout={onLogout}>
            <div className="flex justify-between items-center mb-8">
                <div>
                    <h1 className="text-2xl font-bold text-gray-900">Bank Dashboard</h1>
                    <p className="text-gray-500">Manage loan applications and credit assessments</p>
                </div>
                <Button onClick={handleRefresh}>Refresh Data</Button>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <div className="lg:col-span-2 space-y-8">
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <Card className="bg-blue-50 border-blue-100">
                            <div className="text-blue-600 text-sm font-medium uppercase">Pending Reviews</div>
                            <div className="text-3xl font-bold text-blue-900 mt-1">12</div>
                        </Card>
                        <Card className="bg-green-50 border-green-100">
                            <div className="text-green-600 text-sm font-medium uppercase">Approved Today</div>
                            <div className="text-3xl font-bold text-green-900 mt-1">5</div>
                        </Card>
                        <Card className="bg-purple-50 border-purple-100">
                            <div className="text-purple-600 text-sm font-medium uppercase">Avg Score</div>
                            <div className="text-3xl font-bold text-purple-900 mt-1">712</div>
                        </Card>
                    </div>

                    <ApplicantList applicants={applicants} actions={{ view: handleViewApplicant }} />
                </div>

                <div className="space-y-8">
                    <BatchUpload onUploadComplete={handleRefresh} />

                    <Card title="Quick Actions">
                        <div className="space-y-3">
                            <Button variant="secondary" className="w-full justify-start">New Individual Application</Button>
                            <Button variant="secondary" className="w-full justify-start">Update Risk Thresholds</Button>
                            <Button variant="secondary" className="w-full justify-start">Export Daily Report</Button>
                        </div>
                    </Card>
                </div>
            </div>
        </Layout>
    )
}
