import React from 'react'
import { Card } from '../common/Card'
import { Button } from '../common/Button'

export default function ApplicantList({ applicants, actions }) {
    const getScoreColor = (score) => {
        if (score >= 800) return 'text-green-600'
        if (score >= 740) return 'text-lime-600'
        if (score >= 670) return 'text-yellow-600'
        if (score >= 580) return 'text-orange-600'
        return 'text-red-600'
    }

    return (
        <Card title="Recent Applicants" className="overflow-hidden">
            <div className="overflow-x-auto">
                <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                        <tr>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Applicant ID</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Score</th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                        {applicants.length === 0 ? (
                            <tr>
                                <td colSpan="5" className="px-6 py-4 text-center text-gray-500 text-sm">
                                    No applicants found. Upload a batch to get started.
                                </td>
                            </tr>
                        ) : (
                            applicants.map((app) => (
                                <tr key={app.id} className="hover:bg-gray-50 transition-colors">
                                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                        {app.applicant_id}
                                    </td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        {new Date(app.created_at).toLocaleDateString()}
                                    </td>
                                    <td className="px-6 py-4 whitespace-nowrap text-sm font-bold">
                                        <span className={getScoreColor(app.score)}>{app.score}</span>
                                    </td>
                                    <td className="px-6 py-4 whitespace-nowrap">
                                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full 
                      ${app.status === 'Approved' ? 'bg-green-100 text-green-800' :
                                                app.status === 'Rejected' ? 'bg-red-100 text-red-800' :
                                                    'bg-yellow-100 text-yellow-800'}`}>
                                            {app.status || 'Pending'}
                                        </span>
                                    </td>
                                    <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                                        <Button variant="ghost" size="sm" onClick={() => actions.view(app)}>View</Button>
                                    </td>
                                </tr>
                            ))
                        )}
                    </tbody>
                </table>
            </div>
        </Card>
    )
}
